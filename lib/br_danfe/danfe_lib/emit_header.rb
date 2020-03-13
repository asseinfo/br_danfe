module BrDanfe
  module DanfeLib
    class EmitHeader
      def initialize(pdf, xml, logo, logo_dimensions)
        @pdf = pdf
        @xml = xml
        @logo = logo
        @logo_dimensions = logo_dimensions
      end

      def render(page, y_position)
        @y_position = y_position
        company_box
        danfe_box page
        access_key_box
        sefaz_box
        render_emit y_position
      end

      private

      def company_box
        @pdf.ibox 3.92, 7.46, 0.75, @y_position
        @pdf.ibox 3.92, 7.46, 0.75, @y_position, '', @xml['emit/xNome'],
                  { size: 12, align: :center, border: 0, style: :bold }

        address_company
      end

      def address_company
        if @logo.blank?
          @pdf.ibox 3.92, 7.46, 1.25, @y_position + 1.46, '', address, { align: :left, border: 0 }
        else
          @pdf.ibox 3.92, 7.46, 3.60, @y_position + 1.46, '', address, { size: 8, align: :left, border: 0 }
          logo
        end
      end

      def address
        formatted = @xml['enderEmit/xLgr'] + ', ' + @xml['enderEmit/nro'] + "\n"
        formatted += @xml['enderEmit/xBairro'] + ' - ' + cep + "\n"
        formatted += @xml['enderEmit/xMun'] + '/' + @xml['enderEmit/UF'] + "\n"
        formatted += phone + ' ' + @xml['enderEmit/email']
        formatted
      end

      def phone
        Phone.format(@xml['enderEmit/fone'])
      end

      def cep
        Cep.format(@xml['enderEmit/CEP'])
      end

      def logo
        bounding_box_size = 80
        logo_options = BrDanfe::DanfeLib::LogoOptions.new(bounding_box_size, @logo_dimensions).options

        @pdf.bounding_box(
          [0.83.cm, Helper.invert(@y_position.cm + 1.02.cm)], width: bounding_box_size, height: bounding_box_size
        ) do
          @pdf.image @logo, logo_options
        end
      end

      def danfe_box(page)
        @pdf.ibox 3.92, 2.08, 8.21, @y_position

        @pdf.ibox 0.60, 2.08, 8.21, @y_position, '', 'DANFE',
                  { size: 12, align: :center, border: 0, style: :bold }

        @pdf.ibox 1.20, 2.08, 8.21, @y_position + 0.60, '', I18n.t('danfe.others.danfe'),
                  { size: 8, align: :center, border: 0 }

        @pdf.ibox 0.60, 2.08, 8.21, @y_position + 1.80, '',
                  "#{@xml['ide/tpNF']} - " +
                  (@xml['ide/tpNF'] == '0' ? I18n.t('danfe.ide.tpNF.entry') : I18n.t('danfe.ide.tpNF.departure')),
                  { size: 8, align: :center, border: 0 }

        @pdf.ibox 1.00, 2.08, 8.21, @y_position + 2.40, '',
                  I18n.t('danfe.ide.document', nNF: @xml['ide/nNF'], serie: @xml['ide/serie']),
                  { size: 8, align: :center, valign: :center, border: 0, style: :bold }

        @pdf.ibox 1.00, 2.08, 8.21, @y_position + 3.00, '',
                  I18n.t('danfe.others.page', current: page, total: @pdf.page_count),
                  { size: 8, align: :center, valign: :center, border: 0, style: :bold }
      end

      def access_key_box
        @pdf.ibox 2.22, 10.02, 10.29, @y_position
        @pdf.ibarcode 1.50, 8.00, 10.4010, @y_position + 1.90, @xml['chNFe']
        @pdf.ibox 0.85, 10.02, 10.29, @y_position + 2.22, I18n.t('danfe.chNFe'),
                  @xml['chNFe'].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, '\\1 '), { style: :bold, align: :center }
      end

      def sefaz_box
        @pdf.ibox 0.85, 10.02, 10.29, @y_position + 3.07, '', I18n.t('danfe.others.sefaz'),
                  { align: :center, size: 8 }
      end

      def render_emit(y_position)
        y_first_line = y_position + 3.92
        y_second_line = y_first_line + LINE_HEIGHT

        @pdf.lbox LINE_HEIGHT, 10.04, 0.75, y_first_line, @xml, 'ide/natOp'
        @pdf.ibox LINE_HEIGHT, 9.52, 10.79, y_first_line, I18n.t('danfe.infProt'),
                  "#{@xml['infProt/nProt']} #{Helper.format_datetime(@xml['infProt/dhRecbto'])}", { align: :center }

        @pdf.lie LINE_HEIGHT, 6.36, 0.75, y_second_line, @xml, 'enderEmit/UF', 'emit/IE'
        @pdf.lie LINE_HEIGHT, 6.86, 7.11, y_second_line, @xml, 'enderDest/UF', 'emit/IEST'
        @pdf.lcnpj LINE_HEIGHT, 6.34, 13.97, y_second_line, @xml, 'emit/CNPJ'
      end
    end
  end
end
