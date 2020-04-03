module BrDanfe
  module DanfeLib
    module NfeLib
      class Ticket
        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        def render
          @pdf.ibox 0.85, 15.60, 0.75, 1.85, I18n.t('danfe.ticket.xNome', xNome: @xml['emit/xNome'])
          @pdf.ibox 0.85, 3.85, 0.75, 2.7, I18n.t('danfe.ticket.received_at')
          @pdf.ibox 0.85, 11.75, 4.60, 2.7, I18n.t('danfe.ticket.receiver')
          @pdf.ibox 1.70, 4.00, 16.35, 1.85, '',
                    I18n.t('danfe.ticket.document', nNF: @xml['ide/nNF'], serie: @xml['ide/serie']),
                    align: :center, valign: :center
        end
      end
    end
  end
end
