module BrDanfe
  module DanfeNfceLib
    class Document
      def initialize(page_width, page_height)
        @page_width = page_width
        @page_height = page_height

        @document = Prawn::Document.new(
          page_size: [@page_width, @page_height],
          page_layout: :portrait,
          left_margin: 0.3.cm,
          right_margin: 0.3.cm,
          top_margin: 0,
          botton_margin: 0
        )

        @document.font 'Courier'
        @document.line_width = 0.3
      end

      # FIXME: colocar um attr_reader
      attr_reader :page_height

      def method_missing(method_name, *args, &block)
        if @document.respond_to? method_name
          @document.send method_name, *args, &block
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        @document.respond_to?(method_name, include_private) || super
      end

      def text(text, options = {})
        pad = options.delete(:pad) || 0
        options = { align: :left, size: 7, style: nil }.merge(options)

        pad(pad) do
          @document.text text, size: options[:size], style: options[:style], align: options[:align]
        end
      end

      # FIXME: olhar o do danfe e não ter duplicado
      def iboxI(h, w, x, y, title = '', info = '', options = {})
        box [x.cm, BrDanfe::DanfeNfceLib::Helper.invert(@page_height, y.cm)], w.cm, h.cm, title, info, options
      end

      def ibox(h, w, x, y, title = '', info = '', options = {})
        box [x.cm, y], w.cm, h.cm, title, info, options
      end

      def cnpj(h, w, x, y, info, options = {})
        cnpj = BrDocuments::CnpjCpf::Cnpj.new info
        data = "CNPJ: #{cnpj.valid? ? cnpj.formatted : ''}"

        iboxI(h, w, x, y, '', data, options)
      end

      def inumeric(h, w, x, y, data, options = {})
        numeric [x.cm, y], w.cm, h.cm, '', data, options
      end

      # def ititle(h, w, x, y, i18n)
      #   title = ''
      #   title = I18n.t("danfe.#{i18n}") if i18n != ''
      #   text_box title, size: 8, at: [x.cm, Helper.invert(y.cm) - 4], width: w.cm, height: h.cm, style: :bold
      # end

      # def ibarcode(h, w, x, y, info)
      #   if info != ''
      #     Barby::Code128C.new(info).annotate_pdf(self, x: x.cm, y: Helper.invert(y.cm), width: w.cm, height: h.cm)
      #   end
      # end

      # def lbox(h, w, x, y, xml, xpath, options = {})
      #   i18n = xpath.tr('/', '.')
      #   label = I18n.t("danfe.#{i18n}")
      #   data = xml[xpath]
      #   ibox(h, w, x, y, label, data, options)
      # end

      # def ldate(h, w, x, y, i18n = '', info = '', options = {})
      #   data = Helper.format_date(info)
      #   i18n_lbox(h, w, x, y, i18n, data, options)
      # end

      # def ltime(h, w, x, y, i18n = '', info = '', options = {})
      #   data = Helper.format_time(info)
      #   i18n_lbox(h, w, x, y, i18n, data, options)
      # end

      # def lie(h, w, x, y, xml, xpath_uf, xpath_ie, options = {})
      #   i18n = xpath_ie.tr('/', '.')
      #   data = ''
      #   if BrDanfe::Uf.include?(xml[xpath_uf])
      #     ie = BrDocuments::IE::Factory.create(xml[xpath_uf], xml[xpath_ie])
      #     data = ie.formatted if ie.valid?
      #   end
      #   i18n_lbox(h, w, x, y, i18n, data, options)
      # end

      # def i18n_lbox(h, w, x, y, i18n = '', info = '', options = {})
      #   label = i18n != '' ? I18n.t("danfe.#{i18n}") : ''
      #   ibox h, w, x, y, label, info, options
      # end

      private

      def numeric(at, w, h, title = '', info = '', options = {})
        info = Helper.numerify(info) if info != ''
        box at, w, h, title, info, options.merge({ align: :right })
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
