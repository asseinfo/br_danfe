module RubyDanfe
  class Issqn
    def self.render(pdf, xml)
      pdf.ititle 0.42, 10.00, 0.25, 24.64, "issqn.title"

      pdf.lbox 0.85, 5.08, 0.25, 25.06, xml, "emit/IM"
      pdf.lbox 0.85, 5.08, 5.33, 25.06, xml, "total/vServ"
      pdf.lbox 0.85, 5.08, 10.41, 25.06, xml, "total/vBCISS"
      pdf.lbox 0.85, 5.28, 15.49, 25.06, xml, "total/ISSTot"
    end
  end
end
