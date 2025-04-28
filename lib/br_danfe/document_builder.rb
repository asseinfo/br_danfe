module BrDanfe
  class DocumentBuilder
    def self.build(...)
      document = Prawn::Document.new(...)

      document.font_families['tinos'] = {
        bold: "#{BrDanfe.root_path}/fonts/tinos_bold.ttf",
        italic: "#{BrDanfe.root_path}/fonts/tinos_italic.ttf",
        bold_italic: "#{BrDanfe.root_path}/fonts/tinos_bold_italic.ttf",
        normal: "#{BrDanfe.root_path}/fonts/tinos.ttf"
      }

      document
    end
  end
end
