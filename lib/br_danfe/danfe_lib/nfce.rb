module BrDanfe
  module DanfeLib
    class Nfce < Base
      PAGE_WIDTH = 7.cm
      PAGE_HEIGHT = 100.cm

      private

      def document
        NfceLib::Document.new(PAGE_WIDTH, PAGE_HEIGHT)
      end

      def create_watermark
        @document.create_stamp('has_no_fiscal_value') do
          @document.fill_color '7d7d7d'
          @document.text_box(
            I18n.t('danfe.others.has_no_fiscal_value'),
            size: 0.8.cm,
            width: 10.cm,
            height: 1.2.cm,
            at: [0, PAGE_HEIGHT - 3.8.cm],
            rotate: 45,
            rotate_around: :center
          )
        end
      end

      def generate(footer_info)
        @xmls.each do |xml|
          NfceLib::Header.new(@document, xml, @options.logo, @options.logo_dimensions).render
          NfceLib::ProductList.new(@document, xml).render
          NfceLib::TotalList.new(@document, xml).render
          NfceLib::Key.new(@document, xml).render
          NfceLib::Recipient.new(@document, xml).render
          NfceLib::NfceIdentification.new(@document, xml).render
          BrDanfe::QrCode.new(pdf: @document, qr_code_tag: xml['qrCode'], box_size: 4.5.cm).render
          NfceLib::Footer.new(@document, xml).render(footer_info)

          render_no_fiscal_value(xml)
          resize_page_height
        end

        render_canceled_watermark

        @document
      end

      def render_no_fiscal_value(xml)
        @document.stamp('has_no_fiscal_value') if BrDanfe::Helper.unauthorized?(xml) && !@canceled
      end

      def resize_page_height
        @document.page.dictionary.data[:MediaBox] = [0, @document.y - 10, PAGE_WIDTH, PAGE_HEIGHT]
      end

      def render_canceled_watermark
        return unless @canceled

        create_cancel_watermark

        @document.page_count.times do |i|
          @document.go_to_page(i + 1)
          @document.canvas do
            spacing = 10.cm

            (0..@document.bounds.width).step(spacing).each do |x|
              (0..@document.bounds.height).step(spacing).each do |y|
                @document.stamp_at('canceled', [x, y])
              end
            end
          end
        end
      end

      def create_cancel_watermark
        return unless @canceled

        @document.create_stamp('canceled') do
          @document.fill_color '7d7d7d'
          @document.font_size 1.cm
          @document.rotate(45, origin: [0, 0]) do
            @document.transparent(0.3) do
              @document.draw_text I18n.t('danfe.others.canceled'), at: [1.cm, 0]
            end
          end
        end
      end
    end
  end
end
