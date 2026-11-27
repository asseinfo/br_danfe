module BrDanfe
  module DanfeLib
    module NfeLib
      class Issqn
        attr_reader :y_position

        Y_POSITION = 25.72 + SPACE_BETWEEN_GROUPS
        SERV = 'total/ISSQNtot/vServ'.freeze
        BC = 'total/ISSQNtot/vBC'.freeze
        ISS = 'total/ISSQNtot/vISS'.freeze
        private_constant :SERV, :BC, :ISS

        def self.offset(xml)
          RtcLayout.applies?(xml) && informed?(xml) ? LINE_HEIGHT + SPACE_BETWEEN_GROUPS : 0.0
        end

        def self.informed?(xml)
          xml[SERV].to_f.positive? || xml[BC].to_f.positive? || xml[ISS].to_f.positive?
        end

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @y_position = RtcLayout.applies?(@xml) ? position_below_the_tax_totals : Y_POSITION
          @title = @y_position - 0.42
        end

        def render
          if self.class.informed?(@xml)
            @pdf.ititle 0.42, 10.00, 0.75, @title, 'issqn.title'
            @pdf.lbox LINE_HEIGHT, 4.64, 0.75, @y_position, @xml, 'emit/IM'
            @pdf.lnumeric LINE_HEIGHT, 5.14, 5.39, @y_position, @xml, SERV
            @pdf.lnumeric LINE_HEIGHT, 5.14, 10.53, @y_position, @xml, BC
            @pdf.lnumeric LINE_HEIGHT, 4.64, 15.67, @y_position, @xml, ISS
          end
        end

        private

        def position_below_the_tax_totals
          y_position = Entrega.delivery_local?(@xml) ? Transp::Y_POSITION + 3.00 : Transp::Y_POSITION
          y_position + EmitHeader.offset(@xml) + Icmstot.offset(@xml) + Ibscbstot.offset(@xml)
        end
      end
    end
  end
end
