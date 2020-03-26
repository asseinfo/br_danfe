module BrDanfe
  module DanfeNfceLib
    class Key
      LINE_HEIGHT = 1.35

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        @pdf.y -= 0.6.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'Consulte pela Chave de Acesso em', { size: 7, align: :center, border: 0, style: :bold }
        @pdf.y -= 0.3.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', @xml['urlChave'], { size: 7, align: :center, border: 0 }
        @pdf.y -= 0.3.cm
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', @xml['chNFe'].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, '\\1 '), { size: 6, align: :center, border: 0 }
      end
    end
  end
end
