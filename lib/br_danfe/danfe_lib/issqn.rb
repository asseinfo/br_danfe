module BrDanfe
  module DanfeLib
    class Issqn
      Y = 25.72 + SPACE_BETWEEN_GROUPS

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml

        @ltitle = Y - 0.42
        @l1 = Y

        @serv = "total/ISSQNtot/vServ"
        @bc = "total/ISSQNtot/vBC"
        @iss = "total/ISSQNtot/vISS"
      end

      def render
        if can_render?
          @pdf.ititle 0.42, 10.00, 0.75, @ltitle, "issqn.title"
          @pdf.lbox LINE_HEIGHT, 4.64, 0.75, @l1, @xml, "emit/IM"
          @pdf.lnumeric LINE_HEIGHT, 5.14, 5.39, @l1, @xml, @serv
          @pdf.lnumeric LINE_HEIGHT, 5.14, 10.53, @l1, @xml, @bc
          @pdf.lnumeric LINE_HEIGHT, 4.64, 15.67, @l1, @xml, @iss
        end
      end

      private

      def can_render?
        (@xml[@serv].to_i > 0) || (@xml[@bc].to_i > 0) || (@xml[@iss].to_i > 0)
      end
    end
  end
end
