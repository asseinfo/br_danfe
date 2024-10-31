module BrDanfe
  module DanfeLib
    module NfeLib
      class Issqn
        attr_reader :y_position

        Y_POSITION = 25.72 + SPACE_BETWEEN_GROUPS

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @y_position = Entrega.can_render?(@xml) ? Y_POSITION + 3.00 : Y_POSITION
          @title = @y_position - 0.42

          @serv = 'total/ISSQNtot/vServ'
          @bc = 'total/ISSQNtot/vBC'
          @iss = 'total/ISSQNtot/vISS'
        end

        def render
          if can_render?
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
