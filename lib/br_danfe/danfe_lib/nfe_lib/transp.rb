module BrDanfe
  module DanfeLib
    module NfeLib
      class Transp
        Y = 15.89 + SPACE_BETWEEN_GROUPS

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @ltitle = Y - 0.42
          @l1 = Y
          @l2 = Y + LINE_HEIGHT
        end

        def render(has_delivery)
          if has_delivery
            @ltitle += 3.00
            @l1 += 3.00
            @l2 += 3.00
          end

          @pdf.ititle 0.42, 10.00, 0.75, @ltitle, 'transporta.title'

          @pdf.lbox LINE_HEIGHT, 8.52, 0.75, @l1, @xml, 'transporta/xNome'
          @pdf.i18n_lbox LINE_HEIGHT, 2.79, 9.27, @l1, 'transp.modFrete.title', mod_frete
          @pdf.lbox LINE_HEIGHT, 1.78, 12.06, @l1, @xml, 'veicTransp/RNTC'
          @pdf.i18n_lbox LINE_HEIGHT, 2.29, 13.84, @l1, 'veicTransp.placa', plate
          @pdf.lbox LINE_HEIGHT, 0.76, 16.13, @l1, @xml, 'veicTransp/UF'
          @pdf.lcnpj LINE_HEIGHT, 3.44, 16.89, @l1, @xml, 'transporta/CNPJ'
          @pdf.lbox LINE_HEIGHT, 8.52, 0.75, @l2, @xml, 'transporta/xEnder'
          @pdf.lbox LINE_HEIGHT, 6.86, 9.27, @l2, @xml, 'transporta/xMun'
          @pdf.lbox LINE_HEIGHT, 0.76, 16.13, @l2, @xml, 'transporta/UF'
          @pdf.lie LINE_HEIGHT, 3.44, 16.89, @l2, @xml, 'transporta/UF', 'transporta/IE'
        end

        private

        def plate
          Plate.format(@xml['veicTransp/placa'])
        end

        def mod_frete
          case @xml['transp/modFrete']
          when '0'
            modality = 'emitter'
          when '1'
            modality = 'recipient'
          when '2'
            modality = 'third_party'
          when '3'
            modality = 'own_emitter'
          when '4'
            modality = 'own_recipient'
          when '9'
            modality = 'no_freight'
          end

          I18n.t("danfe.transp.modFrete.#{modality}")
        end
      end
    end
  end
end
