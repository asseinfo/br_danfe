module BrDanfe
  class XML
    def css(xpath)
      @xml.css(xpath)
    end

    def initialize(xml)
      @xml = Nokogiri::XML(xml)
    end

    def [](xpath)
      node = @xml.css(xpath)
      node ? node.text : ''
    end

    def collect(ns, tag)
      result = []
      # With namespace
      begin
        @xml.xpath("//#{ns}:#{tag}").each do |det|
          byebug
          result << yield(det)
        end
      rescue StandardError
        # Without namespace
        @xml.xpath("//#{tag}").each do |det|
          result << yield(det)
        end
      end
      result
    end

    def version_is_310_or_newer?
      @xml.css('infNFe').attr('versao').to_s.to_f >= 3.10
    end
  end
end
