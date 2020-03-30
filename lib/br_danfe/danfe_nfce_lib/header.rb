module BrDanfe
  module DanfeNfceLib
    class Header
      def initialize(pdf, xml, logo, logo_dimensions)
        @pdf = pdf
        @xml = xml
        @logo = logo
        @logo_dimensions = logo_dimensions
      end

      def render
        cursor = @pdf.cursor

        render_company_info(cursor)
        render_logo(cursor) if @logo.present?

        render_homologation if BrDanfe::Helper.homologation?(@xml)
      end

      private

      def render_company_info(cursor)
        x_position = @logo.present? ? 1.7.cm : 0
        width_box = @logo.present? ? 5.7.cm : 7.4.cm

        @pdf.bounding_box([x_position, cursor], width: width_box, height: 45) do
          @pdf.text "#{@xml['emit/xNome']}", size: 7, align: :left, style: :bold
          @pdf.text cnpj(@xml['emit/CNPJ']), size: 6, align: :left
          @pdf.text BrDanfe::DanfeNfceLib::Helper.address(@xml.css('enderEmit')), size: 6, align: :left
          @pdf.render_blank_line
          @pdf.text 'Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica', size: 6, align: :left
        end
      end

      def cnpj(info)
        cnpj = BrDocuments::CnpjCpf::Cnpj.new info
        data = "CNPJ: #{cnpj.valid? ? cnpj.formatted : ''}"
        data
      end

      def render_logo(cursor)
        box_size = 45
        logo_options = BrDanfe::Logo::Options.new(box_size, @logo_dimensions).options

        @pdf.bounding_box([0, cursor], width: box_size, height: box_size) do
          @pdf.image @logo, logo_options
        end
      end

      def render_homologation
        @pdf.render_blank_line
        @pdf.text 'EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO – SEM VALOR FISCAL', size: 7, align: :center, style: :bold
      end
    end
  end
end
