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
        render_logo(cursor)

        render_homologation if BrDanfe::DanfeNfceLib::Helper.homologation?(@xml)
      end

      private

      def render_company_info(cursor)
        @pdf.bounding_box([1.7.cm, cursor], width: 5.7.cm, height: 300) do
          @pdf.text "#{@xml['emit/xNome']}", size: 7, align: :left, style: :bold
          @pdf.text Helper.cnpj(@xml['emit/CNPJ']), size: 6, align: :left
          @pdf.text address.strip, size: 6, align: :left
          @pdf.render_blank_line
          @pdf.text 'Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica', size: 5, align: :left
        end
      end

      def render_homologation
        @pdf.render_blank_line
        @pdf.text 'EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO – SEM VALOR FISCAL',  size: 7, align: :center, style: :bold
      end

      # FIXME: refatorar com o endereço do destinatário
      def address
        "#{@xml['enderEmit/xLgr']}, #{@xml['enderEmit/nro']}, #{@xml['enderEmit/xBairro']}, #{@xml['enderEmit/xMun']} - #{@xml['enderEmit/UF']}"
      end

      # FIXME: ver se não ficou duplicado
      def render_logo(cursor)
        box_size = 45
        logo_options = BrDanfe::Helper::Logo::Options.new(box_size, @logo_dimensions).options

        @pdf.bounding_box([0, cursor], width: box_size, height: box_size) do
          @pdf.image @logo, logo_options
        end
      end

      # FIXME
      # Criar um componente que eu passe o texto e ele já formata certinho, com as options já pré-definidas

      # FIXME: criar
      # def address_company
      #   if @logo.blank?
      #     @pdf.ibox 3.92, 7.46, 1.25, @y_position + 1.46, '', address, { align: :left, border: 0 }
      #   else
      #     @pdf.ibox 3.92, 7.46, 3.60, @y_position + 1.46, '', address, { size: 8, align: :left, border: 0 }
      #     logo
      #   end
      # end
    end
  end
end
