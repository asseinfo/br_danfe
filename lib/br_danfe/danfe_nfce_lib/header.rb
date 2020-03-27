module BrDanfe
  module DanfeNfceLib
    class Header
      LINE_HEIGHT = 1.35

      def initialize(pdf, xml, logo, logo_dimensions)
        @pdf = pdf
        @xml = xml
        @logo = logo
        @logo_dimensions = logo_dimensions
        # @y_position = 5
      end

      # FIXME
      # remover o title
      # fazer o Width(7.4) - o Y
      # border: 0
      # remover o guard
      def render
        #
        # @pdf.bounding_box([1.7.cm, @pdf.cursor], width: 5.7.cm, height: LINE_HEIGHT) do
        #   @pdf.text "<b>Texto</b>", inline_format: true, align: :left
        # end

        # y = BrDanfe::DanfeNfceLib::Helper.invert(100.cm, 0.cm)
        # @pdf.draw_text @xml['emit/xNome'], at: [1.7.cm, @pdf.cursor], size: 7, style: :bold

        @pdf.bounding_box([1.7.cm, @pdf.cursor], width: 5.7.cm, height: 300) do
          @pdf.text @xml['emit/xNome'], size: 7, align: :left, style: :bold
        end

        # @pdf.text_box @xml['emit/xNome'], size: 7, at: [1.7.cm, y], width: 5.7.cm - 4, height: LINE_HEIGHT, align: :left,
        #   style: :bold

        # @pdf.iboxI LINE_HEIGHT, 5.7, 1.7, 0, '', @xml['emit/xNome'], { size: 7, align: :left, border: 0, style: :bold }
        # @pdf.cnpj LINE_HEIGHT, 5.7, 1.7, 0.25, @xml['emit/CNPJ'], { size: 7, align: :left, border: 0 }
        # @pdf.iboxI LINE_HEIGHT, 5.7, 1.7, 0.50, '', address, { size: 7, align: :left, border: 0 }
        # @pdf.iboxI LINE_HEIGHT, 5.7, 1.7, 1.25, '', 'Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica', { size: 6, align: :left, border: 0 }


        # @pdf.text "<b>Texto</b>", inline_format: true, align: :left
        # @pdf.y += @pdf.height_of("Texto")
        # @pdf.text "Texto", inline_format: true, align: :right

        #FIXME: testar com endereço de mais de duas linhas
        logo
      end

      private

      # FIXME: refatorar com o endereço do destinatário
      def address
        "#{@xml['enderEmit/xLgr']}, #{@xml['enderEmit/nro']}, #{@xml['enderEmit/xBairro']}, #{@xml['enderEmit/xMun']} - #{@xml['enderEmit/UF']}"
      end

      # FIXME: ver se não ficou duplicado
      def logo
        box_size = 45
        logo_options = BrDanfe::Helper::Logo::Options.new(box_size, @logo_dimensions).options

        @pdf.bounding_box([0, BrDanfe::DanfeNfceLib::Helper.invert(@pdf.page_height, 0.cm)], width: box_size, height: box_size) do
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
