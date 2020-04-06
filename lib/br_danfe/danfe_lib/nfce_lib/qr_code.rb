module BrDanfe
  module DanfeLib
    module NfceLib
      class QrCode
        require 'rqrcode'
        require 'chunky_png'
        require 'tempfile'

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
        end

        def render
          qrcode = RQRCode::QRCode.new(@xml['qrCode'])
          image = Tempfile.new(%w[qrcode png], binmode: true)
          image.write(qrcode.as_png(module_px_size: 12).to_s)

          box_size = 3.cm
          @pdf.image image, width: box_size, height: box_size, position: :center
        end
      end
    end
  end
end
