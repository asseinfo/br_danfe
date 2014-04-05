module BrDanfe
  class IeMasks
    def apply_mask_for_sp(ie)
      if ie.length == 12
        ie.sub(/(\d{3})(\d{3})(\d{3})(\d{3})/, "\\1.\\2.\\3.\\4")
      else
        ie.sub(/(\w{1})(\d{8})(\d{1})(\d{3})/, "\\1-\\2.\\3/\\4")
      end
    end

    def apply_mask_for_ba(ie)
      if ie.length == 8
        ie.sub(/(\d{6})(\d{2})/, "\\1-\\2")
      else
        ie.sub(/(\d{7})(\d{2})/, "\\1-\\2")
      end
    end

    def apply_mask_for_ro(ie)
      if ie.length == 9
        ie.sub(/(\d{3})(\d{5})(\d{1})/, "\\1.\\2-\\3")
      else
        ie.sub(/(\d{13})(\d{1})/, "\\1-\\2")
      end
    end

    def apply_mask_for_rn(ie)
      if ie.length == 9
        ie.sub(/(\d{2})(\d{3})(\d{3})(\d{1})/, "\\1.\\2.\\3-\\4")
      else
        ie.sub(/(\d{2})(\d{1})(\d{3})(\d{3})(\d{1})/, "\\1.\\2.\\3.\\4-\\5")
      end
    end

    def apply_mask_for_ac(ie)
      ie.sub(/(\d{2})(\d{3})(\d{3})(\d{3})(\d{2})/, "\\1.\\2.\\3/\\4-\\5")
    end

    def apply_mask_for_df(ie)
      ie.sub(/(\d{11})(\d{2})/, "\\1-\\2")
    end

    def apply_mask_for_mg(ie)
      ie.sub(/(\d{3})(\d{3})(\d{3})(\d{4})/, "\\1.\\2.\\3/\\4")
    end

    def apply_mask_for_mt(ie)
      ie.sub(/(\d{10})(\d{1})/, "\\1-\\2")
    end

    def apply_mask_for_rj(ie)
      ie.sub(/(\d{2})(\d{3})(\d{2})(\d{1})/, "\\1.\\2.\\3-\\4")
    end

    def apply_mask_for_pr(ie)
      ie.sub(/(\d{8})(\d{2})/, "\\1-\\2")
    end

    def apply_mask_for_rs(ie)
      ie.sub(/(\d{3})(\d{7})/, "\\1/\\2")
    end

    def apply_mask_for_pe(ie)
      ie.sub(/(\d{7})(\d{2})/, "\\1-\\2")
    end

    def apply_mask_for_pa(ie)
      ie.sub(/(\d{2})(\d{6})(\d{1})/, "\\1-\\2-\\3")
    end

    def apply_mask_for_sc(ie)
      ie.sub(/(\d{3})(\d{3})(\d{3})/, "\\1.\\2.\\3")
    end
  end
end
