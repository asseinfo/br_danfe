module BrDanfe
  class Danfe
    def self.new(xmls)
      xmls = [xmls] unless xmls.is_a?(Array)

      parsed_xmls = []
      xmls.each do |xml|
        parsed_xmls << BrDanfe::XML.new(xml)
      end

      create_danfe(parsed_xmls)
    end

    def self.create_danfe(xmls)
      nfce_code = '65'
      xmls.first['ide > mod'] == nfce_code ? DanfeLib::Nfce.new(xmls) : DanfeLib::Nfe.new(xmls)
    end
    private_class_method :create_danfe
  end
end
