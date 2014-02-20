module RubyDanfe
  class Ticket
    def self.render(pdf, xml)
      pdf.ibox 0.85, 16.10, 0.25, 0.42, I18n.t("danfe.ticket.xNome", xNome: xml["emit/xNome"])
      pdf.ibox 0.85, 4.10, 0.25, 1.27, I18n.t("danfe.ticket.received_at")
      pdf.ibox 0.85, 12.00, 4.35, 1.27, I18n.t("danfe.ticket.receiver")
      pdf.ibox 1.70, 4.50, 16.35, 0.42, "", I18n.t("danfe.ticket.document", nNF: xml["ide/nNF"], serie: xml["ide/serie"]), {align: :center, valign: :center}
    end
  end
end
