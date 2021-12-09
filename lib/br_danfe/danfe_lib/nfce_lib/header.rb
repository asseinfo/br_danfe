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

          render_company_info
          render_logo(cursor) if @logo.present?
          render_doc

          render_homologation if BrDanfe::Helper.homologation?(@xml)
        end

        private

        def render_company_info
          one_line = 1

          @pdf.text_box (@xml['emit/xNome']).to_s, at: [x_position, @pdf.cursor], height: 36, size: 9, align: :left, style: :bold, overflow: :shrink_to_fit
          @pdf.move_down 36

          @pdf.text_box cnpj(@xml['emit/CNPJ']), at: [x_position, @pdf.cursor], height: 9, size: 9, align: :left, overflow: :shrink_to_fit
          @pdf.move_down 9

          @pdf.text_box BrDanfe::DanfeLib::NfceLib::Helper.address(@xml.css('enderEmit')), at: [x_position, @pdf.cursor], height: 20, size: 9, align: :left, overflow: :shrink_to_fit
          @pdf.move_down 20
          @pdf.render_blank_line if count_name_lines(@xml['emit/xNome']) == one_line
        end

        def x_position
          @logo.present? ? 2.2.cm : 0
        end

        def width_box
          @logo.present? ? 4.5.cm : 6.7.cm
        end

        def cnpj(info)
          cnpj = BrDocuments::CnpjCpf::Cnpj.new info
          "CNPJ: #{cnpj.valid? ? cnpj.formatted : ''}"
        end

        def count_name_lines(company_name)
          company_name.scan(/([\s\S]{1,38}( |$)|[\s\S]{1,38})/).length
        end

        def render_logo(cursor)
          box_size = 60
          logo_options = BrDanfe::Logo::Options.new(box_size, @logo_dimensions).options

          @pdf.bounding_box([0, cursor], width: box_size, height: box_size) do
            @pdf.image @logo, logo_options
          end
        end

        def render_doc
          @pdf.render_blank_line

          @pdf.bounding_box([0, @pdf.cursor], width: 6.7.cm, height: 20) do
            @pdf.text 'Documento Auxiliar da Nota Fiscal de Consumidor Eletrônica', size: 9, align: :center
          end
        end

        def render_homologation
          2.times { @pdf.render_blank_line }

          @pdf.bounding_box([0, @pdf.cursor], width: 6.7.cm, height: 20) do
            @pdf.text 'EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO', size: 8, align: :center, style: :bold
            @pdf.text 'SEM VALOR FISCAL', size: 8, align: :center, style: :bold
          end
        end
      end
    end
  end
end
