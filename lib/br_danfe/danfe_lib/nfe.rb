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
        nfe_code = '55'

        last_index = @xmls.size - 1

        @xmls.each_with_index do |xml, index|
          break unless xml['ide > mod'] == nfe_code

          initial_number_of_pages = @document.page_count

          render_on_first_page(xml)

          render_on_each_page(footer_info, xml, initial_number_of_pages)

          @document.start_new_page unless index == last_index
        end

        @document
      end

      def render_on_first_page(xml)
        NfeLib::Ticket.new(@document, xml).render
        NfeLib::Dest.new(@document, xml).render
        NfeLib::Dup.new(@document, xml).render
        NfeLib::Icmstot.new(@document, xml).render
        NfeLib::Transp.new(@document, xml).render
        n_vol = NfeLib::Vol.new(@document, xml).render
        has_issqn = NfeLib::Issqn.new(@document, xml).render
        NfeLib::Infadic.new(@document, xml).render(n_vol)

        render_products(has_issqn, xml)
      end

      def render_products(has_issqn, xml)
        NfeLib::DetBody.new(@document, xml).render(has_issqn)
      end

      def render_on_each_page(footer_info, xml, initial_number_of_pages)
        total_pages = @document.page_count + 1 - initial_number_of_pages

        emitter = NfeLib::EmitHeader.new(@document, xml, @options.logo, @options.logo_dimensions)

        total_pages.times do |page_index|
          page = page_index + initial_number_of_pages

          position = page_index + 1 == 1 ? 3.96 : 1.85
          repeated_information(page, position, emitter, footer_info, xml, total_pages, page_index + 1)
        end
      end

      def repeated_information(page, y_position, emitter, footer_info, xml, total_pages, initial_page_of_xml)
        @document.go_to_page(page)

        emitter.render(initial_page_of_xml, y_position, total_pages)
        render_product_table_title initial_page_of_xml
        render_footer_information footer_info
        render_no_fiscal_value(xml)
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

      def render_no_fiscal_value(xml)
        @document.stamp('has_no_fiscal_value') if BrDanfe::Helper.no_fiscal_value?(xml)
      end
    end
  end
end
