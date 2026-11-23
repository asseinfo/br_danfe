module BrDanfe
  module DanfeLib
    module NfeLib
      class EmitHeader
        OPERATION_TYPE_BOX_LINE_WIDTH = 0.75

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
                    size: 8, align: :center, border: 0, style: :bold

          address_company
        end

        def address_company
          if @logo.blank?
            @pdf.ibox 3.92, 7.46, 0.75, @y_position + 1.46, '', address, align: :center, border: 0, leading: 2
          else
            @pdf.ibox 3.92, 4.7, 3.65, @y_position + 1.46, '', address, align: :left, border: 0, leading: 2
            logo
          end
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
                    size: 8, align: :center, border: 0, style: :bold

          @pdf.fill_color LABEL_COLOR
          @pdf.ibox 1.20, 2.08, 8.21, @y_position + 0.60, '', I18n.t('danfe.others.danfe'),
                    size: 4.5, align: :center, border: 0
          @pdf.fill_color TEXT_COLOR

          operation_type_box

          @pdf.ibox 0.32, 2.08, 8.21, @y_position + 2.55, '',
                    I18n.t('danfe.ide.nNF', nNF: Helper.format_number(@xml['ide/nNF'])),
                    size: 5.5, align: :center, border: 0
          @pdf.ibox 0.32, 2.08, 8.21, @y_position + 2.80, '',
                    I18n.t('danfe.ide.serie', serie: Helper.format_serie(@xml['ide/serie'])),
                    size: 5, align: :center, border: 0

          @pdf.ibox 1.00, 2.08, 8.21, @y_position + 3.00, '',
                    I18n.t('danfe.others.page', current: page, total: total),
                    size: 5, align: :center, valign: :center, border: 0
        end

        def operation_type_box
          @pdf.ibox 0.60, 1.50, 8.21, @y_position + 1.80, '',
                    "0 - #{I18n.t('danfe.ide.tpNF.entry')}\n1 - #{I18n.t('danfe.ide.tpNF.departure')}",
                    size: 5, valign: :center, border: 0
          @pdf.line_width OPERATION_TYPE_BOX_LINE_WIDTH
          @pdf.ibox 0.55, 0.55, 9.66, @y_position + 1.83, '', @xml['ide/tpNF'],
                    size: 6.5, align: :center, valign: :center
          @pdf.line_width LINE_WIDTH
        end

        def access_key_box
          @pdf.ibox 2.22, 10.02, 10.29, @y_position
          @pdf.ibarcode 1.50, 8.00, 10.4010, @y_position + 1.90, @xml['infProt > chNFe']
          @pdf.ibox 0.85, 10.02, 10.29, @y_position + 2.22, I18n.t('danfe.chNFe'),
                    @xml['infProt > chNFe'].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, '\\1 '), size: 6.5, style: :bold,
                    align: :center
        end

        def sefaz_box
          @pdf.fill_color LABEL_COLOR
          @pdf.ibox 0.85, 10.02, 10.29, @y_position + 3.07, '', I18n.t('danfe.others.sefaz'),
                    valign: :center, size: 4.5
          @pdf.fill_color TEXT_COLOR
        end

        def render_emit(y_position)
          y_first_line = y_position + 3.92
          y_second_line = y_first_line + LINE_HEIGHT

          @pdf.lbox LINE_HEIGHT, 10.04, 0.75, y_first_line, @xml, 'ide/natOp'
          @pdf.ibox LINE_HEIGHT, 9.52, 10.79, y_first_line, I18n.t('danfe.infProt'),
                    "#{@xml['infProt/nProt']} #{BrDanfe::Helper.format_datetime(@xml['infProt/dhRecbto'])}", align: :right

          @pdf.lie LINE_HEIGHT, 6.36, 0.75, y_second_line, @xml, 'enderEmit/UF', 'emit/IE'
          @pdf.lie LINE_HEIGHT, 6.86, 7.11, y_second_line, @xml, 'enderDest/UF', 'emit/IEST'
          @pdf.lcnpj_cpf LINE_HEIGHT, 6.34, 13.97, y_second_line, @xml, cnpj_cpf, align: :right
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
