module BrDanfe
  module DanfeLib
    module NfeLib
      class Document
        def initialize
          @document = BrDanfe::DocumentBuilder.build(
            page_size: 'A4',
            page_layout: :portrait,
            left_margin: 0,
            right_margin: 0,
            top_margin: 0,
            botton_margin: 0
          )

          @document.font 'tinos'

          @document.line_width = 0.3
        end

        def method_missing(method_name, ...)
          if @document.respond_to? method_name
            @document.send(method_name, ...)
          else
            super
          end
        end

        def respond_to_missing?(method_name, include_private = false)
          @document.respond_to?(method_name, include_private) || super
        end

        def ititle(h, w, x, y, i18n)
          title = ''
          title = I18n.t("danfe.#{i18n}") if i18n != ''

          text_box title, size: 8, at: [x.cm, Helper.invert(y.cm) - 4], width: w.cm, height: h.cm, style: :bold
        end

        def ibarcode(h, w, x, y, info)
          if info != ''
            Barby::Code128C.new(info).annotate_pdf(self, x: x.cm, y: Helper.invert(y.cm), width: w.cm, height: h.cm)
          end
        end

        def ibox(h, w, x, y, title = '', info = '', options = {})
          box [x.cm, Helper.invert(y.cm)], w.cm, h.cm, title, info, options
        end

        def lbox(h, w, x, y, xml, xpath, options = {})
          i18n = xpath.tr('/', '.')
          label = I18n.t("danfe.#{i18n}")
          data = xml[xpath]

          ibox(h, w, x, y, label, data, options)
        end

        def ldate(h, w, x, y, i18n = '', info = '', options = {})
          data = Helper.format_date(info)
          i18n_lbox(h, w, x, y, i18n, data, options)
        end

        def ltime(h, w, x, y, i18n = '', info = '', options = {})
          data = Helper.format_time(info)
          i18n_lbox(h, w, x, y, i18n, data, options)
        end

        def lcnpj(h, w, x, y, xml, xpath, options = {})
          i18n = xpath.tr('/', '.')

          cnpj = BrDocuments::CnpjCpf::Cnpj.new(xml[xpath])
          data = if cnpj.valid?
                   cnpj.formatted
                 else
                   ''
                 end

          i18n_lbox(h, w, x, y, i18n, data, options)
        end

        def lie(h, w, x, y, xml, xpath_uf, xpath_ie, options = {})
          i18n = xpath_ie.tr('/', '.')

          data = ''
          if BrDanfe::Uf.include?(xml[xpath_uf])
            ie = BrDocuments::IE::Factory.create(xml[xpath_uf], xml[xpath_ie])
            data = ie.formatted if ie.valid?
          end

          i18n_lbox(h, w, x, y, i18n, data, options)
        end

        def lnumeric(h, w, x, y, xml, xpath, options = {})
          i18n = xpath.tr('/', '.')
          data = xml[xpath]

          inumeric(h, w, x, y, i18n, data, options)
        end

        def inumeric(h, w, x, y, i18n = '', data = '', options = {})
          label = i18n == '' ? '' : I18n.t("danfe.#{i18n}")
          numeric [x.cm, Helper.invert(y.cm)], w.cm, h.cm, label, data, options
        end

        def i18n_lbox(h, w, x, y, i18n = '', info = '', options = {})
          label = i18n == '' ? '' : I18n.t("danfe.#{i18n}")
          ibox h, w, x, y, label, info, options
        end

        private

        def numeric(at, w, h, title = '', info = '', options = {})
          info = BrDanfe::Helper.numerify(info) if info != ''
          box at, w, h, title, info, options.merge(align: :right)
        end

        def box(at, w, h, title = '', info = '', options = {})
          options = {
            align: :left,
            size: 10,
            style: nil,
            valign: :top,
            border: 1
          }.merge(options)

          stroke_rectangle at, w, h if options[:border] == 1

          at[0] += 2

          if title != ''
            title_coord = Array.new(at)
            title_coord[1] -= 2
            text_box title, size: 6, at: title_coord, width: w - 4, height: 8
          end

          title_adjustment = title == '' ? 4 : 13
          at[1] -= title_adjustment
          text_box info, size: options[:size], at: at, width: w - 4, height: h - title_adjustment, align: options[:align],
            style: options[:style], valign: options[:valign]
        end
      end
    end
  end
end
