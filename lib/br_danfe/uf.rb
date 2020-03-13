module BrDanfe
  class Uf
    def self.include?(uf)
      uf.present? ? all.include?(uf.to_sym) : false
    end

    def self.all
      [:AC, :AL, :AP, :AM, :BA, :CE, :DF, :ES, :GO, :MA, :MT, :MS, :MG, :PA, :PB, :PR, :PE, :PI, :RJ, :RN, :RS, :RO, :RR, :SC, :SP, :SE, :TO]
    end
    private_class_method :all
  end
end
