module BrDanfe
  module DanfeLib
    module NfeLib
      class DetRow
        HEADER = [
          'prod.cProd', 'prod.xProd', 'prod.NCM', 'ICMS.CST', 'prod.CFOP', 'prod.uCom', 'prod.qCom',
          'prod.vUnCom', 'prod.vProd', 'ICMS.vBC', 'ICMS.vICMS', 'IPI.vIPI', 'ICMS.pICMS', 'IPI.pIPI'
        ].freeze
        private_constant :HEADER

        def self.titles
          HEADER.map { |key| I18n.t("danfe.det.#{key}") }
        end

        def self.column_widths
          {
            0 => 1.60.cm, 1 => 6.10.cm, 2 => 1.05.cm, 3 => 0.60.cm, 4 => 0.70.cm, 5 => 1.05.cm, 6 => 1.20.cm,
            7 => 1.20.cm, 8 => 1.20.cm, 9 => 1.20.cm, 10 => 1.00.cm, 11 => 1.00.cm, 12 => 0.90.cm, 13 => 0.76.cm
          }
        end

        def initialize(_pdf, det)
          @det = det
        end

        def render
          [
            cell_text(@det.css('prod/cProd').text),
            cell_text(Xprod.new(@det).render),
            cell_text(@det.css('prod/NCM').text),
            cell_text(Cst.to_danfe(@det)),
            cell_text(@det.css('prod/CFOP').text),
            cell_text(@det.css('prod/uCom').text),
            cell_number(numerify('prod/qCom')),
            cell_number(numerify('prod/vUnCom')),
            cell_number(numerify('prod/vProd')),
            cell_number(numerify('ICMS/*/vBC')),
            cell_number(numerify('ICMS/*/vICMS')),
            cell_number(numerify('IPI/*/vIPI')),
            cell_number(numerify('ICMS/*/pICMS')),
            cell_number(numerify('IPI/*/pIPI'))
          ]
        end

        private

        def cell_text(text, options = {})
          cell = { content: text, border_lines: [:solid], size: 6 }
          cell.merge!(options)
          cell
        end

        def cell_number(text)
          cell_text(text, align: :right)
        end

        def numerify(xpath)
          BrDanfe::Helper.numerify(@det.css(xpath.to_s).text)
        end
      end
    end
  end
end
