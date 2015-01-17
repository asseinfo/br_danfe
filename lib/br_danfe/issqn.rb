module BrDanfe
  class Issqn
    Y = 24.60 + SPACE_BETWEEN_GROUPS

    def initialize(pdf, xml)
      @pdf = pdf
      @xml = xml

      @ltitle = Y - 0.42
      @l1 = Y
    end

    def render
      @pdf.ititle 0.42, 10.00, 0.25, @ltitle, "issqn.title"

      @pdf.lbox LINE_HEIGHT, 5.14, 0.25, @l1, @xml, "emit/IM"
      @pdf.lbox LINE_HEIGHT, 5.14, 5.39, @l1, @xml, "total/vServ"
      @pdf.lbox LINE_HEIGHT, 5.14, 10.53, @l1, @xml, "total/vBCISS"
      @pdf.lbox LINE_HEIGHT, 5.14, 15.67, @l1, @xml, "total/ISSTot"
    end
  end
end
