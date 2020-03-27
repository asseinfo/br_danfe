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
          top_margin: 0.3.cm,
          botton_margin: 0
        )

        @document.font 'Courier'
        @document.line_width = 0.3
      end

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

      # FIXME: olhar o do danfe e não ter duplicado
      def iboxI(h, w, x, y, title = '', info = '', options = {})
        box [x.cm, BrDanfe::DanfeNfceLib::Helper.invert(@page_height, y.cm)], w.cm, h.cm, title, info, options
      end

      def ibox(h, w, x, y, title = '', info = '', options = {})
        box [x.cm, y], w.cm, h.cm, title, info, options
      end

      # FIXME: talvez não seja necessário estar extraido, tem o cnpj do emit e do dest
      def cnpj(h, w, x, y, info, options = {})
        cnpj = BrDocuments::CnpjCpf::Cnpj.new info
        data = "CNPJ: #{cnpj.valid? ? cnpj.formatted : ''}"

        iboxI(h, w, x, y, '', data, options)
      end

      def inumeric(h, w, x, y, data, options = {})
        numeric [x.cm, y], w.cm, h.cm, '', data, options
      end

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
