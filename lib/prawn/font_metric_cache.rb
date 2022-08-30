module Prawn
  # Cache used internally by Prawn::Document instances to calculate the width
  # of various strings for layout purposes.
  #
  # @private
  class FontMetricCache
    CacheEntryMonkeyPatch = Struct.new(:font, :font_size, :options, :string)

    def width_of(string, options)
      encoded_string = @document.font.normalize_encoding(string)

      key = CacheEntryMonkeyPatch.new(@document.font, @document.font_size, options, encoded_string)

      @cache[key] ||= @document.font.compute_width_of(encoded_string, options)

      length = @cache[key]

      character_count = @document.font.character_count(encoded_string)
      if character_count.positive?
        length += @document.character_spacing * (character_count - 1)
      end

      length
    end
  end
end
