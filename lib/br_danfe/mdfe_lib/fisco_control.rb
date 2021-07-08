module BrDanfe
  module MdfeLib
    class FiscoControl
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        title
        barcode
        render_nfe_key
      end

      private

      def title
        title = 'CONTROLE DO FISCO'

        @pdf.text_box(title, size: 9, align: :left, at: [250, 600])
      end

      def barcode
        barcode = Barby::Code128C.new(nfe_key)
        barcode.annotate_pdf(@pdf, x: 250, y: 526, height: 50)
      end

      def nfe_key
        @xml['mdfeProc > protMDFe > infProt > chMDFe']
      end

      def render_nfe_key
        title = 'Chave de Acesso'

        @pdf.text_box(title, size: 9, align: :left, style: :bold, at: [250, 500])
        @pdf.text_box(nfe_key, size: 11, align: :left, at: [250, 490])
      end
    end
  end
end
