module BrDanfe
  module DanfeLib
    module NfceLib
      class NfceIdentification
        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        def render
          emitted_at = BrDanfe::Helper.format_datetime(@xml['ide/dhEmi'])
          identification = "NFC-e nº #{@xml['ide/nNF']} Série #{@xml['ide/serie']} #{emitted_at}"

          @pdf.render_blank_line
          @pdf.text identification, size: 9, align: :center, style: :bold
          @pdf.text "<b>Protocolo de autorização:</b> #{@xml['infProt/nProt']}", size: 9, align: :center, inline_format: true
          @pdf.text "<b>Data de autorização: </b> #{BrDanfe::Helper.format_datetime(@xml['infProt/dhRecbto'])}", size: 9, align: :center, inline_format: true
        end
      end
    end
  end
end
