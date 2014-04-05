module BrDanfe
  class Ie
    def self.format(ie, uf)
      uf = uf.upcase

      if ["AL", "AP", "MA", "ES", "MS", "PI", "TO"].include?(uf)
        formatted = ie
      elsif ["CE", "PB", "RR", "SE"].include?(uf)
        formatted = ie.sub(/(\d{8})(\d{1})/, "\\1-\\2")
      elsif ["AM", "GO"].include?(uf)
        formatted = ie.sub(/(\d{2})(\d{3})(\d{3})(\d{1})/, "\\1.\\2.\\3-\\4")
      else
        masks = IeMasks.new
        formatted = masks.send("apply_mask_for_#{uf.downcase}", ie)
      end

      formatted
    end
  end
end
