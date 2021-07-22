module BrDanfe
  module MdfeLib
    class AuthorizationProtocol
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def generate
        authorization
      end

      private

      def authorization
        title = 'Protocolo de autorização'
        protocol = @xml['infProt/nProt'] + ' - ' + Helper.format_datetime(@xml['infProt/dhRecbto'], true)

        @pdf.text_box(title, size: 9, align: :left, style: :bold, at: [0, 510])
        @pdf.text_box(protocol, size: 11, align: :left, at: [0, 500])
      end
    end
  end
end
