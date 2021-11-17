module BrDanfe
  module MdfeLib
    class FiscoControl
      def initialize(pdf, xml)
        @pdf = pdf
        @nfe_key = xml['mdfeProc > protMDFe > infProt > chMDFe']
      end

      def generate
        @pdf.text_box('CONTROLE DO FISCO', size: 9, align: :left, at: [250, 600])

        return if @nfe_key.blank?

        Barby::Code128C.new(@nfe_key).annotate_pdf(@pdf, x: 250, y: 530, height: 50)

        @pdf.text_box('Chave de Acesso', size: 9, align: :left, style: :bold, at: [250, 510])
        @pdf.text_box(@nfe_key, size: 11, align: :left, at: [250, 500])
      end
    end
  end
end
