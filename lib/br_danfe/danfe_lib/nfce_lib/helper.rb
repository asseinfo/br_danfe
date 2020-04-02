module BrDanfe
  module DanfeLib
    module NfceLib
      class Helper
        def self.address(ender_tag)
          "#{ender_tag.css('xLgr').text}, #{ender_tag.css('nro').text}, #{ender_tag.css('xBairro').text}, #{ender_tag.css('xMun').text} - #{ender_tag.css('UF').text}"
        end
      end
    end
  end
end
