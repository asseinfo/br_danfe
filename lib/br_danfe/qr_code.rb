module BrDanfe
  class QrCode
    require 'rqrcode'
    require 'chunky_png'
    require 'tempfile'

    def initialize(pdf:, xml:, qr_code_tag:, box_size:)
      @pdf = pdf
      @xml = xml
      @qr_code_tag = qr_code_tag
      @box_size = box_size
    end

    def render
      qrcode = RQRCode::QRCode.new(@qr_code_tag)
      image = Tempfile.new(%w[qrcode png], binmode: true)
      image.write(qrcode.as_png(module_px_size: 12).to_s)

      @pdf.image(image, width: @box_size, height: @box_size, position: :center)
    end
  end
end
