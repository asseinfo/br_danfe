module BrDanfe
  module DanfeLib
    module NfeLib
      class Vol
        Y = 21.01

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @l1 = Y
        end

        def render
          nVol = 0

          @xml.collect('xmlns', 'vol') do |det|
            nVol += 1
            render_vol(det) if nVol < 2
          end

          render_blank_boxes if nVol.zero?

          nVol
        end

        private

        def render_vol(det)
          @pdf.ibox 0.85, 2.42, 0.75, @l1, I18n.t('danfe.vol.qVol'), det.css('qVol').text
          @pdf.ibox 0.85, 3.05, 3.17, @l1, I18n.t('danfe.vol.esp'), det.css('esp').text
          @pdf.ibox 0.85, 3.05, 6.22, @l1, I18n.t('danfe.vol.marca'), det.css('marca').text
          @pdf.ibox 0.85, 4.83, 9.27, @l1, I18n.t('danfe.vol.nVol')
          @pdf.inumeric 0.85, 3.43, 14.10, @l1, 'vol.pesoB', det.css('pesoB').text, decimals: 3
          @pdf.inumeric 0.85, 2.80, 17.53, @l1, 'vol.pesoL', det.css('pesoL').text, decimals: 3
        end

        def render_blank_boxes
          render_vol(@xml)
        end
      end
    end
  end
end
