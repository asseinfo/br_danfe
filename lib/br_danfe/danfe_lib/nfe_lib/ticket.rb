module BrDanfe
  module DanfeLib
    module NfeLib
      class Ticket
        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        def render
          render_additional_data
          @pdf.ibox 0.85, 3.85, 0.75, 2.7, I18n.t('danfe.ticket.received_at')
          @pdf.ibox 0.85, 11.75, 4.60, 2.7, I18n.t('danfe.ticket.receiver')
          @pdf.ibox 1.70, 4.00, 16.35, 1.85, '',
                    I18n.t('danfe.ticket.document', nNF: @xml['ide/nNF'], serie: @xml['ide/serie']),
                    align: :center, valign: :center
        end

        def render_additional_data
          data = generate_additional_data
          @pdf.ibox 0.85, 15.60, 0.75, 1.85, '', data, size: 6
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
