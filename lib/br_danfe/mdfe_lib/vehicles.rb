module BrDanfe
  module MdfeLib
    class Vehicles
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        title
        table_titles
        render_vehicles
        # vehicles
      end

      private

      def title
        title = 'Veículo'

        @pdf.text_box(title, size: 12, align: :left, style: :bold, at: [0, 460])
      end

      def table_titles
        plate = 'Placa'
        rntrc = 'RNTRC'

        @pdf.stroke_horizontal_line(0, 190, at: 430)
        @pdf.text_box(plate, size: 9, align: :left, at: [0, 440])
        @pdf.text_box(rntrc, size: 9, align: :left, at: [100, 440])
      end

      def render_vehicles
        vehicles.each_with_index do |vehicle, vehicles_index|
          vehicle.each_with_index do |cell, vehicle_index|
            @pdf.bounding_box [teste(vehicle_index), 425 - vehicles_index * 15], width: 1000, height: 1000 do
              @pdf.text cell[:content], cell[:options]
            end
          end
        end
      end

      def vehicles
        vehicle = []
        vehicle += collect_vehicles('veicReboque')
        vehicle += collect_vehicles('veicTracao')

        vehicle
      end

      def teste(index)
        index.even? ? 0 : 100
      end

      def collect_vehicles(tag)
        @xml.collect('xmlns', tag) { |rodo| vehicle(rodo) }
      end

      def vehicle(rodo)
        [
          cell_text(rodo.css('placa').text),
          cell_text('')
        ]
      end

      def cell_text(text, options = {})
        cell = { content: text, options: { size: 12, width: 100 } }
        cell[:options].merge!(options)
        cell
      end
    end
  end
end
