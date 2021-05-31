module BrDanfe
  class Danfe
    def self.new(xmls)
      xmls = [xmls] unless xmls.is_a?(Array)

      parsed_xmls = xmls.map { |xml| BrDanfe::XML.new(xml) }

      create_danfe(parsed_xmls)
    end

    def self.create_danfe(xmls)
      nfe?(xmls) ? DanfeLib::Nfe.new(xmls) : DanfeLib::Nfce.new(xmls)
    end
    private_class_method :create_danfe

    def self.nfe?(xmls)
      nfe_code = '55'

      xmls.first['ide > mod'] == nfe_code
    end
    private_class_method :nfe?
  end
end
