module BrDanfe
  class Danfe
    def self.new(xmls)
      xmls = [xmls] unless xmls.is_a?(Array)

      parsed_xmls = xmls.map { |xml| BrDanfe::XML.new(xml) }

      create_danfe(parsed_xmls)
    end

    def self.create_danfe(xmls)
      DanfeLib::Nfe.new(xmls)
    end
    private_class_method :create_danfe
  end
end
