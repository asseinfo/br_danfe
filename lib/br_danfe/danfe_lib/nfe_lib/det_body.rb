module BrDanfe
  module DanfeLib
    module NfeLib
      class DetBody
        TABLE_CELL_PADDING = 2
        TABLE_WITH_ONLY_HEADER = 1
        private_constant :TABLE_WITH_ONLY_HEADER

        attr_reader :y_position_with_entrega

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @y_position_with_entrega = Entrega.delivery_local?(@xml) ? 3.00 : 0.00
          @first_page_offset = @y_position_with_entrega + RtcLayout.offset(@xml)
          @row = RtcLayout.applies?(@xml) ? RtcDetRow : DetRow
        end

        def render(has_issqn)
          table_height_on_first_page = table_height_on_first_page has_issqn
          first_table = create_table
          next_table = create_table

          fill_tables first_table, next_table, table_height_on_first_page
          render_tables first_table, next_table, table_height_on_first_page
        end

        private

        def table_height_on_first_page(has_issqn)
          base_height = has_issqn && !RtcLayout.applies?(@xml) ? 6.35.cm : 7.72.cm
          base_height - @first_page_offset.cm
        end

        def create_table
          [create_header]
        end

        def create_header
          @pdf.make_table([@row.titles.map { |title| header_cell(title) }], options)
        end

        def header_cell(content)
          {
            content: content, align: :center, size: 5, valign: :top, font_style: :bold,
            background_color: TITLE_BACKGROUND_COLOR, padding: [4, TABLE_CELL_PADDING, 3.5, TABLE_CELL_PADDING]
          }
        end

        def options
          {
            column_widths: @row.column_widths,
            cell_style: { padding: [0.5, TABLE_CELL_PADDING, 1.5, TABLE_CELL_PADDING], border_width: LINE_WIDTH }
          }
        end

        def fill_tables(first_table, next_table, first_table_height)
          total_height = first_table.first.height

          @xml.collect('xmlns', 'det') { _1 }.each do |det|
            row = create_row(@row.new(@pdf, det).render)
            total_height += row.height
            total_height <= first_table_height ? first_table << row : next_table << row
          end
        end

        def create_row(data)
          @pdf.make_table([data], options)
        end

        def render_tables(first_table, next_table, first_table_height)
          products_on_first_page = products_on_first_page?(first_table, next_table)
          render_table first_table, table_position_on_first_page, first_table_height if products_on_first_page

          if next_table.size > TABLE_WITH_ONLY_HEADER
            @pdf.start_new_page
            render_table next_table, table_position_on_next_pages, table_height_on_next_pages
          end

          products_on_first_page
        end

        def products_on_first_page?(first_table, next_table)
          first_table.size > TABLE_WITH_ONLY_HEADER || next_table.size == TABLE_WITH_ONLY_HEADER
        end

        def render_table(data, start_position, height)
          @pdf.y = start_position
          @pdf.bounding_box [0.75.cm, @pdf.cursor], width: 19.56.cm, height: height do
            @pdf.table data.map { |item| [item] }, header: true, cell_style: { border_width: 0 }
          end
        end

        def table_position_on_first_page
          y_position = @first_page_offset.cm + 18.07.cm
          Helper.invert(y_position)
        end

        def table_position_on_next_pages
          Helper.invert(6.57.cm)
        end

        def table_height_on_next_pages
          22.58.cm
        end
      end
    end
  end
end
