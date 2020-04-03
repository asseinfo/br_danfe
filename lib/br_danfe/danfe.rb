module BrDanfe
  class Danfe
    def self.new(xml)
      create_danfe BrDanfe::XML.new(xml)
    end

    def self.create_danfe(xml)
      nfe_code = '55'
      xml['mod'] == nfe_code ? DanfeLib::Nfe.new(xml) : DanfeLib::Nfce.new(xml)
    end
    private_class_method :create_danfe
  end
end
