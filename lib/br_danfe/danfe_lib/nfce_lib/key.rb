module BrDanfe
  module DanfeLib
    module NfceLib
      class Key
        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        def render
          @pdf.render_blank_line

          @pdf.text 'Consulte pela Chave de Acesso em', size: 7, align: :center, style: :bold
          @pdf.text @xml['urlChave'], size: 7, align: :center
          @pdf.text @xml['chNFe'].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, '\\1 '), size: 6, align: :center
        end
      end
    end
  end
end
