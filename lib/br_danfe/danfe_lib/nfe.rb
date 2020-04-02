module BrDanfe
  module DanfeLib
    class Nfe < Base
      private

      def document
        NfeLib::Document.new
      end

      def create_watermark
        @document.create_stamp('has_no_fiscal_value') do
          @document.fill_color '7d7d7d'
          @document.text_box I18n.t('danfe.others.has_no_fiscal_value'),
                        size: 2.2.cm,
                        width: @document.bounds.width,
                        height: @document.bounds.height,
                        align: :center,
                        valign: :center,
                        at: [0, @document.bounds.height],
                        rotate: 45,
                        rotate_around: :center
        end
      end

      def generate(footer_info)
        render_on_first_page
        render_on_each_page footer_info
        @document
      end

      def render_on_first_page
        NfeLib::Ticket.new(@document, @xml).render
        NfeLib::Dest.new(@document, @xml).render
        NfeLib::Dup.new(@document, @xml).render
        NfeLib::Icmstot.new(@document, @xml).render
        NfeLib::Transp.new(@document, @xml).render
        n_vol = NfeLib::Vol.new(@document, @xml).render
        has_issqn = NfeLib::Issqn.new(@document, @xml).render
        NfeLib::Infadic.new(@document, @xml).render(n_vol)

        render_products has_issqn
      end

      def render_products(has_issqn)
        NfeLib::DetBody.new(@document, @xml).render(has_issqn)
      end

      def render_on_each_page(footer_info)
        emitter = NfeLib::EmitHeader.new(@document, @xml, @options.logo, @options.logo_dimensions)

        @document.page_count.times do |i|
          page = i + 1
          position = page == 1 ? 3.96 : 1.85
          repeated_information page, position, emitter, footer_info
        end
      end

      def repeated_information(page, y_position, emitter, footer_info)
        @document.go_to_page(page)

        emitter.render page, y_position
        render_product_table_title page
        render_footer_information footer_info
        render_no_fiscal_value
      end

      def render_product_table_title(page)
        y_position = page == 1 ? 18.91 : 7.40
        @document.ititle 0.42, 10.00, 0.75, y_position, 'det.title'
      end

      def render_footer_information(footer_info)
        if footer_info.present?
          @document.ibox 0.35, 12.45, 0.75, 30.21, '', footer_info, size: 5, border: 0
        end
      end

      def render_no_fiscal_value
        @document.stamp('has_no_fiscal_value') if NfeLib::Helper.no_fiscal_value?(@xml)
      end
    end
  end
end
