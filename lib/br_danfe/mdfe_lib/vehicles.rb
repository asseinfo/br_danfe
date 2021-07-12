module BrDanfe
  module MdfeLib
    class Vehicles
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        @pdf.move_cursor_to 460

        title
        table_titles
        render_vehicles
      end

      private

      def title
        title = 'Veículo'

        @pdf.text_box(title, size: 12, align: :left, style: :bold, at: [0, @pdf.cursor])
      end

      def table_titles
        plate = 'Placa'
        rntrc = 'RNTRC'

        @pdf.stroke_color GRAY_COLOR
        @pdf.move_down 20
        @pdf.text_box(plate, size: 9, align: :left, at: [0, @pdf.cursor])
        @pdf.text_box(rntrc, size: 9, align: :left, at: [100, @pdf.cursor])
        @pdf.move_down 10
        @pdf.stroke_horizontal_line(0, 190, at: @pdf.cursor)
      end

      def render_vehicles
        @pdf.move_cursor_to 425

        vehicles.each_with_index do |cell, index|
          @pdf.bounding_box [0, @pdf.cursor], width: 190, height: 20 do
            @pdf.stroke_color GRAY_COLOR
            @pdf.dash([2], phase: 6)
            @pdf.stroke_horizontal_line(0, 190, at: 26) unless index.zero?
            @pdf.text cell[:content], cell[:options]
            @pdf.undash
            @pdf.move_down 20
          end
        end
      end

      def vehicles
        vehicle = []
        vehicle += collect_vehicles('veicReboque')
        vehicle += collect_vehicles('veicTracao')

        vehicle
      end

      def collect_vehicles(tag)
        vehicles = []
        @xml.collect('xmlns', tag) { |rodo| vehicles += vehicle(rodo) }
        vehicles
      end

      def vehicle(rodo)
        [
          cell_text(rodo.css('placa').text)
        ]
      end

      def cell_text(text, options = {})
        cell = { content: text, options: { size: 12 } }
        cell[:options].merge!(options)
        cell
      end
    end
  end
end
