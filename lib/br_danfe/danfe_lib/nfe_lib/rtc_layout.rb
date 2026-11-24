module BrDanfe
  module DanfeLib
    module NfeLib
      class RtcLayout
        START_DATE = Date.new(2026, 12, 1)

        def self.applies?(xml)
          xml['IBSCBSTot'].present? || issued_from_start_date?(xml)
        end

        def self.offset(xml)
          Icmstot.offset(xml) + IbscbsTot.offset(xml)
        end

        def self.issued_from_start_date?(xml)
          issued_at = xml['ide/dhEmi'].presence || xml['ide/dEmi']
          return false if issued_at.blank?

          Date.parse(issued_at[0, 10]) >= START_DATE
        end
      end
    end
  end
end
