module BrDanfe
  module DanfeLib
    module NfeLib
      class Issqn
        Y_POSITION = 25.72 + SPACE_BETWEEN_GROUPS

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @title = Y_POSITION - 0.42
          @y_position = Y_POSITION

          @serv = 'total/ISSQNtot/vServ'
          @bc = 'total/ISSQNtot/vBC'
          @iss = 'total/ISSQNtot/vISS'
        end

        def render(has_delivery)
          if can_render?
            if has_delivery
              @title += 3.00
              @y_position += 3.00
            end

            @pdf.ititle 0.42, 10.00, 0.75, @title, 'issqn.title'
            @pdf.lbox LINE_HEIGHT, 4.64, 0.75, @y_position, @xml, 'emit/IM'
            @pdf.lnumeric LINE_HEIGHT, 5.14, 5.39, @y_position, @xml, @serv
            @pdf.lnumeric LINE_HEIGHT, 5.14, 10.53, @y_position, @xml, @bc
            @pdf.lnumeric LINE_HEIGHT, 4.64, 15.67, @y_position, @xml, @iss
          end
        end

        private

        def can_render?
          @xml[@serv].to_f.positive? || @xml[@bc].to_f.positive? || @xml[@iss].to_f.positive?
        end
      end
    end
  end
end
