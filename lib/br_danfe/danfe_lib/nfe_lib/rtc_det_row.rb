module BrDanfe
  module DanfeLib
    module NfeLib
      class RtcDetRow
        COLUMNS = [
          'description', 'cst_cfop', 'quantity_unit', 'unit_value', 'total_value', 'bases', 'rates', 'taxes'
        ].freeze
        COLUMN_WIDTHS = [4.15, 1.30, 1.30, 1.45, 1.55, 2.69, 3.30, 3.82].freeze
        LABEL_RATIOS = {
          single: [0.50, 0.50], rates: [0.28, 0.22, 0.28, 0.22], taxes: [0.24, 0.26, 0.24, 0.26]
        }.freeze
        FONT_SIZE = 6
        IBSCBS = 'imposto/IBSCBS'.freeze
        GROUP = "#{IBSCBS}/gIBSCBS".freeze
        private_constant :COLUMN_WIDTHS, :LABEL_RATIOS, :FONT_SIZE, :IBSCBS, :GROUP

        def self.column_widths
          COLUMN_WIDTHS.map(&:cm)
        end

        def initialize(pdf, det)
          @pdf = pdf
          @det = det
        end

        def render
          [
            description,
            labeled(COLUMN_WIDTHS[1], [[['CST', Cst.to_danfe(@det)]], [['CFOP', text('prod/CFOP')]]], :single),
            quantity,
            cell(value('prod/vUnCom'), align: :right),
            cell(value('prod/vProd'), align: :right),
            labeled(COLUMN_WIDTHS[5], bases.map { |pair| [pair] }, :single),
            labeled(COLUMN_WIDTHS[6], rates, :rates),
            labeled(COLUMN_WIDTHS[7], taxes, :taxes)
          ]
        end

        private

        def description
          name, additional_information = Xprod.new(@det).render.split("\n", 2)
          lines = [escape(name.to_s), gray(additional_information), gray(codes)]
          cell(lines.compact_blank.join("\n"), inline_format: true)
        end

        def escape(content)
          content.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;')
        end

        def gray(content)
          return nil if content.blank?

          "<color rgb='#{LABEL_COLOR}'>#{escape(content)}</color>"
        end

        def codes
          [
            "[#{I18n.t('danfe.det.code')} #{text('prod/cProd')}]",
            ("[#{I18n.t('danfe.det.ncm')} #{text('prod/NCM')}]" if text('prod/NCM').present?),
            ("[cClassTrib #{text("#{IBSCBS}/cClassTrib")}]" if text("#{IBSCBS}/cClassTrib").present?)
          ].compact.join(' ')
        end

        def text(xpath)
          @det.css(xpath).text
        end

        def cell(content, options = {})
          { content: content, size: FONT_SIZE }.merge(options)
        end

        def labeled(width, lines, ratios)
          rows = lines.reject { |pairs| pairs.all? { |_label, content| content.blank? } }.map { |pairs| labeled_row(pairs) }
          return cell('') if rows.empty?

          @pdf.make_table(
            rows,
            column_widths: LABEL_RATIOS.fetch(ratios).map { |ratio| (width.cm - (CELL_PADDING * 2)) * ratio },
            cell_style: { borders: [], size: FONT_SIZE }
          )
        end

        def labeled_row(pairs)
          pairs.flat_map do |label, content|
            [
              { content: content.blank? ? '' : label, text_color: LABEL_COLOR, padding: [0, 1, 0, 0] },
              { content: content.to_s, align: :right, padding: [0, 2, 0, 0] }
            ]
          end
        end

        def quantity
          unit = text('prod/uCom')
          lines = [value('prod/qCom'), (gray("[#{unit}]") if unit.present?)]
          cell(lines.compact.join("\n"), align: :center, inline_format: true)
        end

        def value(xpath)
          content = text(xpath)
          content.present? ? BrDanfe::Helper.numerify(content) : ''
        end

        def bases
          [
            ['ICMS', value('ICMS/*/vBC')], ['IBS / CBS', value("#{GROUP}/vBC")],
            ['IS', value('imposto/IS/vBCIS')], ['IPI', value('IPI/*/vBC')]
          ]
        end

        def rates
          [
            [['ICMS', percent(text('ICMS/*/pICMS'))], ['CBS', ibscbs_rate('gCBS', 'pCBS')]],
            [['IBS UF', ibscbs_rate('gIBSUF', 'pIBSUF')], ['IPI', percent(text('IPI/*/pIPI'))]],
            [['IBS MUN', ibscbs_rate('gIBSMun', 'pIBSMun')], ['IS', percent(text('imposto/IS/pIS'))]]
          ]
        end

        def percent(number)
          return '' if number.blank?

          formatted = format('%.4f', BigDecimal(number)).sub(/0{1,2}\z/, '')
          "#{formatted.tr('.', ',')}%"
        end

        def ibscbs_rate(group, rate_tag)
          effective_rate = text("#{GROUP}/#{group}/gRed/pAliqEfet")
          percent(effective_rate.presence || text("#{GROUP}/#{group}/#{rate_tag}"))
        end

        def taxes
          [
            [['ICMS', value('ICMS/*/vICMS')], ['CBS', value("#{GROUP}/gCBS/vCBS")]],
            [['IBS UF', value("#{GROUP}/gIBSUF/vIBSUF")], ['IPI', value('IPI/*/vIPI')]],
            [['IBS MUN', value("#{GROUP}/gIBSMun/vIBSMun")], ['IS', value('imposto/IS/vIS')]]
          ]
        end
      end
    end
  end
end
