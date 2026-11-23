module BrDanfe
  module DanfeLib
    module NfeLib
      class Ticket
        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        CUT_LINE_Y_POSITION = 3.75
        CUT_LINE_WIDTH = 0.48
        CUT_LINE_COLOR = '888888'.freeze

        def render
          render_additional_data
          @pdf.ibox 0.85, 3.85, 0.75, 2.7, I18n.t('danfe.ticket.received_at'), ''
          @pdf.ibox 0.85, 11.75, 4.60, 2.7, I18n.t('danfe.ticket.receiver'), ''
          render_document
          render_cut_line
        end

        def render_additional_data
          data = generate_additional_data
          @pdf.ibox 0.85, 15.60, 0.75, 1.85, '', data, size: 6, style: :bold, valign: :center
        end

        def render_document
          @pdf.ibox 1.70, 3.96, 16.35, 1.85
          @pdf.ibox 0.55, 3.96, 16.35, 1.95, '', I18n.t('danfe.ticket.title'),
                    size: 12, align: :center, border: 0, style: :bold
          @pdf.ibox 0.45, 3.96, 16.35, 2.45, '', I18n.t('danfe.ide.nNF', nNF: Helper.format_number(@xml['ide/nNF'])),
                    size: 10, align: :center, border: 0, style: :bold
          @pdf.ibox 0.45, 3.96, 16.35, 2.88, '', I18n.t('danfe.ide.serie', serie: Helper.format_serie(@xml['ide/serie'])),
                    size: 10, align: :center, border: 0, style: :bold
        end

        def render_cut_line
          y = Helper.invert(CUT_LINE_Y_POSITION.cm)
          @pdf.line_width CUT_LINE_WIDTH
          @pdf.stroke_color CUT_LINE_COLOR
          @pdf.dash [1.44, 0.48]
          @pdf.stroke_line [0.75.cm, y], [(0.75 + CONTENT_WIDTH).cm, y]
          @pdf.undash
          @pdf.stroke_color TEXT_COLOR
          @pdf.line_width LINE_WIDTH
        end

        def generate_additional_data
          additional_data = []
          additional_data.push(name_content)
          additional_data.push("DESTINATÁRIO: #{recipient_content}")
          additional_data.push("EMITIDA EM: #{emmited_at_content}")
          additional_data.push("VALOR TOTAL DA NOTA: R$ #{total_value_content}")
          additional_data.join(' * ')
        end

        def name_content
          I18n.t('danfe.ticket.xNome', xNome: @xml['emit/xNome'])
        end

        def recipient_content
          @xml['dest/xNome'].to_s
        end

        def total_value_content
          BrDanfe::Helper.numerify(@xml['ICMSTot/vNF']).to_s
        end

        def emmited_at_content
          @xml['ide/dhEmi'].present? ? Helper.format_date(@xml['ide/dhEmi']) : Helper.format_date(@xml['ide/dEmi'])
        end
      end
    end
  end
end
