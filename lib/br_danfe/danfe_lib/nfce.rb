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
        create_stamp('canceled', size: 1.1.cm, width: 12.cm, at: [-0.5.cm, PAGE_HEIGHT - 5.cm])
        create_stamp('has_no_fiscal_value', size: 0.8.cm)
      end

      def generate(footer_info)
        @xmls.each do |xmls|
          xml, event_xmls = xmls

          NfceLib::Header.new(@document, xml, @options.logo, @options.logo_dimensions).render
          NfceLib::ProductList.new(@document, xml).render
          NfceLib::TotalList.new(@document, xml).render
          NfceLib::Key.new(@document, xml).render
          NfceLib::Recipient.new(@document, xml).render
          NfceLib::NfceIdentification.new(@document, xml).render
          BrDanfe::QrCode.new(pdf: @document, qr_code_tag: xml['qrCode'], box_size: 4.5.cm).render
          NfceLib::Footer.new(@document, xml).render(footer_info)

          render_no_fiscal_value(xml)
          render_canceled(xml, event_xmls)
          resize_page_height
        end

        @document
      end

      def resize_page_height
        @document.page.dictionary.data[:MediaBox] = [0, @document.y - 10, PAGE_WIDTH, PAGE_HEIGHT]
      end

      def render_no_fiscal_value(xml)
        @document.stamp('has_no_fiscal_value') if BrDanfe::Helper.unauthorized?(xml)
      end

      def render_canceled(xml, event_xmls)
        @document.stamp('canceled') if BrDanfe::Helper.canceled?(xml, event_xmls)
      end

      def create_stamp(name, extra_config = {})
        @document.create_stamp(name) do
          @document.fill_color '7d7d7d'
          @document.transparent(0.5) do
            @document.text_box(
              I18n.t("danfe.others.#{name}"),
              {
                width: 10.cm,
                height: 1.2.cm,
                at: [0, PAGE_HEIGHT - 3.8.cm],
                rotate: 45,
                rotate_around: :center
              }.merge(extra_config)
            )
          end
        end
      end
    end
  end
end
