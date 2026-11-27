module BrDanfe
  module DanfeLib
    module NfeLib
      class EmitHeader
        IDENTIFICATION_SIZE = 10
        DESCRIPTION_SIZE = 8

        def self.offset(xml)
          RtcLayout.applies?(xml) ? LINE_HEIGHT : 0.0
        end

        def initialize(pdf, xml, logo, logo_dimensions)
          @pdf = pdf
          @xml = xml
          @logo = logo
          @logo_dimensions = logo_dimensions
        end

        def render(page, y_position, total)
          @y_position = y_position
          company_box
          danfe_box(page, total)
          access_key_box
          sefaz_box
          render_emit y_position
        end

        private

        def company_box
          @pdf.ibox 3.92, 7.46, 0.75, @y_position
          @pdf.ibox 3.92, 7.46, 0.75, @y_position, '', @xml['emit/xNome'],
                    size: 12, align: :center, border: 0, style: :bold

          address_company
        end

        def address_company
          if @logo.blank?
            @pdf.ibox 3.92, 7.46, 0.75, @y_position + 1.46, '', address, address_style.merge(align: :center)
          else
            @pdf.ibox 3.92, 4.7, 3.65, @y_position + 1.46, '', address, address_style.merge(align: :left)
            logo
          end
        end

        def address_style
          { size: DESCRIPTION_SIZE, style: :bold, border: 0, leading: 2 }
        end

        def address
          "#{@xml['enderEmit/xLgr']}, #{@xml['enderEmit/nro']}\n" \
            "#{@xml['enderEmit/xBairro']} - #{cep}\n" \
            "#{@xml['enderEmit/xMun']}/#{@xml['enderEmit/UF']}\n" \
            "#{phone} #{@xml['enderEmit/email']}"
        end

        def phone
          Phone.format(@xml['enderEmit/fone'])
        end

        def cep
          BrDanfe::Helper.format_cep(@xml['enderEmit/CEP'])
        end

        def logo
          bounding_box_size = 80
          logo_options = BrDanfe::Logo::Options.new(bounding_box_size, @logo_dimensions).options

          @pdf.bounding_box(
            [0.83.cm, Helper.invert(@y_position.cm + 1.02.cm)], width: bounding_box_size, height: bounding_box_size
          ) do
            @pdf.image @logo, logo_options
          end
        end

        def danfe_box(page, total)
          @pdf.ibox 3.92, 2.08, 8.21, @y_position

          @pdf.ibox 0.60, 2.08, 8.21, @y_position, '', 'DANFE',
                    size: 12, align: :center, border: 0, style: :bold

          @pdf.ibox 1.40, 2.08, 8.21, @y_position + 0.52, '', I18n.t('danfe.others.danfe'),
                    size: DESCRIPTION_SIZE, align: :center, border: 0

          operation_type_box

          identification_line 2.45, I18n.t('danfe.ide.nNF', nNF: Helper.format_number(@xml['ide/nNF']))
          identification_line 2.88, I18n.t('danfe.ide.serie', serie: Helper.format_serie(@xml['ide/serie']))
          identification_line 3.31, I18n.t('danfe.others.page', current: page, total: total)
        end

        def identification_line(y_offset, text)
          @pdf.ibox 0.45, 2.08, 8.21, @y_position + y_offset, '', text,
                    size: IDENTIFICATION_SIZE, align: :center, border: 0, style: :bold
        end

        def operation_type_box
          operation = @xml['ide/tpNF'] == '0' ? I18n.t('danfe.ide.tpNF.entry') : I18n.t('danfe.ide.tpNF.departure')

          @pdf.formatted_text_box(
            [{ text: @xml['ide/tpNF'], size: IDENTIFICATION_SIZE, styles: [:bold] },
             { text: " - #{operation}", size: DESCRIPTION_SIZE }],
            at: [8.21.cm, Helper.invert((@y_position + 1.92).cm)], width: 2.08.cm, height: 0.50.cm,
            align: :center, valign: :center
          )
        end

        def access_key_box
          @pdf.ibox 2.22, 10.02, 10.29, @y_position
          @pdf.ibarcode 1.50, 8.00, 10.4010, @y_position + 1.90, @xml['infProt > chNFe']
          @pdf.ibox 0.85, 10.02, 10.29, @y_position + 2.22, I18n.t('danfe.chNFe'),
                    @xml['infProt > chNFe'].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, '\\1 '), style: :bold, align: :center
        end

        def sefaz_box
          @pdf.fill_color LABEL_COLOR
          @pdf.ibox 0.85, 10.02, 10.29, @y_position + 3.07, '', I18n.t('danfe.others.sefaz'),
                    valign: :center, size: DESCRIPTION_SIZE
          @pdf.fill_color TEXT_COLOR
        end

        def render_emit(y_position)
          y_first_line = y_position + 3.92
          y_second_line = y_first_line + LINE_HEIGHT

          @pdf.lbox LINE_HEIGHT, 10.04, 0.75, y_first_line, @xml, 'ide/natOp'
          @pdf.ibox LINE_HEIGHT, 9.52, 10.79, y_first_line, I18n.t('danfe.infProt'),
                    "#{@xml['infProt/nProt']} #{BrDanfe::Helper.format_datetime(@xml['infProt/dhRecbto'])}", align: :right

          render_second_line(y_second_line)
          render_tax_regime_line(y_second_line + LINE_HEIGHT) if RtcLayout.applies?(@xml)
        end

        def render_second_line(y_position)
          @pdf.lie LINE_HEIGHT, 6.36, 0.75, y_position, @xml, 'enderEmit/UF', 'emit/IE'
          @pdf.lie LINE_HEIGHT, 6.86, 7.11, y_position, @xml, 'enderDest/UF', 'emit/IEST'
          @pdf.lcnpj_cpf LINE_HEIGHT, 6.34, 13.97, y_position, @xml, cnpj_cpf, align: :right
        end

        def render_tax_regime_line(y_position)
          @pdf.i18n_lbox LINE_HEIGHT, 10.04, 0.75, y_position, 'emit.CRT.title', described_code('CRT')
          @pdf.i18n_lbox LINE_HEIGHT, 9.52, 10.79, y_position, 'emit.tpRegimeIBSCBS.title', ''
        end

        def described_code(tag)
          code = @xml["emit/#{tag}"]
          code.present? ? I18n.t("danfe.emit.#{tag}.#{code}", default: code) : ''
        end

        def cnpj_cpf
          if @xml['emit/CNPJ'].present?
            'emit/CNPJ'
          else
            'emit/CPF'
          end
        end
      end
    end
  end
end
