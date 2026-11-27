module BrDanfe
  module DanfeLib
    module NfeLib
      class Dup
        attr_reader :y_position

        Y_POSITION = 12.92
        DUP_MAX_QUANTITY = 12
        DUPS_PER_ROW = DUP_MAX_QUANTITY / 2
        LABEL_ROW_HEIGHT = 0.30
        VALUE_ROW_HEIGHT = 0.60
        DUP_WIDTH = CONTENT_WIDTH / DUPS_PER_ROW
        UNTITLED_TEXT_OFFSET = 0.07

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @y_position = Entrega.delivery_local?(@xml) ? Y_POSITION + 3.00 : Y_POSITION
          @y_position += EmitHeader.offset(@xml)

          @ltitle = @y_position - 0.42
        end

        def render
          x = 0.75
          y = @y_position

          @pdf.ititle 0.42, 10.00, x, @ltitle, 'dup.title'

          render_titles_and_box(x, y)

          dups = @xml.collect('xmlns', 'dup') { _1 }[..(DUP_MAX_QUANTITY - 1)]
          line_height = VALUE_ROW_HEIGHT / dups.each_slice(DUPS_PER_ROW).count

          dups.each_with_index do |det, index|
            x = 0.75 if index == DUPS_PER_ROW

            line = index / DUPS_PER_ROW
            render_dup(det, x, y + LABEL_ROW_HEIGHT + (line * line_height), line_height)
            x += DUP_WIDTH
          end
        end

        private

        def render_titles_and_box(x, y)
          DUPS_PER_ROW.times do
            @pdf.ibox LABEL_ROW_HEIGHT, DUP_WIDTH, x, y
            @pdf.ibox VALUE_ROW_HEIGHT, DUP_WIDTH, x, y + LABEL_ROW_HEIGHT
            @pdf.fill_color LABEL_COLOR
            centered_text LABEL_ROW_HEIGHT, 1.80, x, y, I18n.t('danfe.dup.nDup'), label
            centered_text LABEL_ROW_HEIGHT, 1.80, x + 0.87, y, I18n.t('danfe.dup.dVenc'), label
            centered_text LABEL_ROW_HEIGHT, 1.80, x + 2.35, y, I18n.t('danfe.dup.vDup'), label
            @pdf.fill_color TEXT_COLOR
            x += DUP_WIDTH
          end
        end

        def render_dup(det, x, y, height)
          centered_text height, 2.12, x + 0.1, y, det.css('nDup').text, normal
          centered_text height, 2.12, x + 0.75, y, dtduplicata(det), normal
          centered_text height, 2.12, x + 1.1, y, BrDanfe::Helper.numerify(det.css('vDup').text), normal.merge(align: :right)
        end

        def centered_text(height, width, x, y, text, style)
          @pdf.ibox height + UNTITLED_TEXT_OFFSET, width, x, y - UNTITLED_TEXT_OFFSET, '', text,
                    style.merge(valign: :center)
        end

        def dtduplicata(det)
          dtduplicata = det.css('dVenc').text
          "#{dtduplicata[8, 2]}/#{dtduplicata[5, 2]}/#{dtduplicata[0, 4]}"
        end

        def normal
          { size: 6, border: 0 }
        end

        def label
          { size: 6, border: 0 }
        end
      end
    end
  end
end
