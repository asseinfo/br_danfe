module BrDanfe
  module DanfeNfceLib
    LINE_HEIGHT = 1.35

    class NfceIdentification
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        emitted_at = BrDanfe::DanfeNfceLib::Helper.format_datetime(@xml['ide/dhEmi'])
        identification = "NFC-e nº #{@xml['ide/nNF']} Série #{@xml['ide/serie']} #{emitted_at}"

        @pdf.y -= 0.6.cm
        @pdf.text identification, size: 7, align: :center, style: :bold
        @pdf.text "<b>Protocolo de autorização:</b> #{@xml['infProt/nProt']}", size: 7, align: :center, inline_format: true
        @pdf.text "<b>Data de autorização: </b> #{BrDanfe::DanfeNfceLib::Helper.format_datetime(@xml['infProt/dhRecbto'])}", size: 7, align: :center, inline_format: true
      end
    end
  end
end
