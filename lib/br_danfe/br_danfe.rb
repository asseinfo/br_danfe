module BrDanfe
  def self.generate(pdf_filename, xml_filename, new_options = {})
    self.options = new_options if !new_options.empty?

    xml_string = File.new(xml_filename)
    render_file(pdf_filename, xml_string)
  end

  def self.render(xml_string, new_options = {})
    self.options = new_options if !new_options.empty?

    pdf = generatePDF(xml_string)
    pdf.render
  end

  def self.render_file(pdf_filename, xml_string, new_options = {})
   self.options = new_options if !new_options.empty?

    pdf = generatePDF(xml_string)
    pdf.render_file pdf_filename
  end

  def self.options
    @options ||= BrDanfe::Options.new
  end

  private
  def self.generatePDF(xml_string, new_options = {})
    self.options = new_options if !new_options.empty?

    xml = XML.new(xml_string)

    generator = DanfeGenerator.new(xml)

    pdf = generator.generatePDF
    pdf
  end
end
