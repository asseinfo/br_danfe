module BrDanfe
  module DanfeLib
    module NfceLib
      class Header
        def initialize(pdf, xml, logo, logo_dimensions)
          @pdf = pdf
          @xml = xml
          @logo = logo
          @logo_dimensions = logo_dimensions
        end

        def render
          cursor = @pdf.cursor

          render_company_info(cursor)
          render_logo(cursor) if @logo.present?

          render_homologation if BrDanfe::Helper.homologation?(@xml)
        end

        private

        def render_company_info(cursor)
          one_line = 1

          @pdf.bounding_box([x_position, cursor], width: width_box, height: 45) do
            @pdf.text (@xml['emit/xNome']).to_s, size: 7, align: :left, style: :bold
            @pdf.text cnpj(@xml['emit/CNPJ']), size: 6, align: :left
            @pdf.text BrDanfe::DanfeLib::NfceLib::Helper.address(@xml.css('enderEmit')), size: 6, align: :left
            @pdf.render_blank_line if count_name_lines(@xml['emit/xNome']) == one_line
            @pdf.text 'Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica', size: 6, align: :left
          end
        end

        def x_position
          @logo.present? ? 1.7.cm : 0
        end

        def width_box
          @logo.present? ? 5.7.cm : 7.4.cm
        end

        def cnpj(info)
          cnpj = BrDocuments::CnpjCpf::Cnpj.new info
          data = "CNPJ: #{cnpj.valid? ? cnpj.formatted : ''}"
          data
        end

        def count_name_lines(company_name)
          company_name.scan(/([\s\S]{1,38}( |$)|[\s\S]{1,38})/).length
        end

        def render_logo(cursor)
          box_size = 45
          logo_options = BrDanfe::Logo::Options.new(box_size, @logo_dimensions).options

          @pdf.bounding_box([0, cursor], width: box_size, height: box_size) do
            @pdf.image @logo, logo_options
          end
        end

        def render_homologation
          @pdf.render_blank_line
          @pdf.text 'EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO – SEM VALOR FISCAL', size: 7, align: :center, style: :bold
        end
      end
    end
  end
end
