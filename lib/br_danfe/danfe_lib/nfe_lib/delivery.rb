module BrDanfe
  module DanfeLib
    module NfeLib
      class Delivery
        Y = 12.92
        MAXIMUM_SIZE_FOR_STREET = 319

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml
          @xml_version_is_310_or_newer = @xml.version_is_310_or_newer?

          @address = 'enderEntrega/xLgr'

          @ltitle = Y - 0.42
          @l1 = Y
          @l2 = Y + LINE_HEIGHT
          @l3 = Y + (LINE_HEIGHT * 2)
        end

        def render
          if can_render?
            @pdf.ititle 0.42, 10.00, 0.75, @ltitle, 'enderEntrega.title'

            render_line1
            render_line2
            render_line3

            @xml_version_is_310_or_newer ? render_dates_for_nfe_310_or_newer : render_dates_for_older_nfes
          end
        end

        private

        def can_render?
          @xml[@address].to_s.present?
        end

        def render_line1
          @pdf.lbox LINE_HEIGHT, 11.82, 0.75, @l1, @xml, 'dest/xNome'
          render_cnpj_cpf
        end

        def render_cnpj_cpf
          if @xml['enderEntrega/CNPJ'] == ''
            @pdf.i18n_lbox LINE_HEIGHT, 4.37, 12.57, @l1, 'enderEntrega.CPF', cpf
          else
            @pdf.lcnpj LINE_HEIGHT, 4.37, 12.57, @l1, @xml, 'enderEntrega/CNPJ'
          end
        end

        def cpf
          cpf = BrDocuments::CnpjCpf::Cpf.new(@xml['enderEntrega/CPF'])
          cpf.formatted
        end

        def render_line2
          @pdf.i18n_lbox LINE_HEIGHT, 9.66, 0.75, @l2, 'enderEntrega.xLgr', address
          @pdf.lbox LINE_HEIGHT, 4.33, 10.41, @l2, @xml, 'enderEntrega/xBairro'
          @pdf.i18n_lbox LINE_HEIGHT, 2.20, 14.74, @l2, 'enderEntrega.cMun', cep
        end

        def address
          address = Helper.generate_address @xml

          if Helper.address_is_too_big(@pdf, address)
            address = address[0..address.length - 2] while Helper.mensure_text(@pdf, "#{address.strip}...") > MAXIMUM_SIZE_FOR_STREET && !address.empty?
            address = "#{address.strip}..."
          end
          address
        end

        def cep
          BrDanfe::Helper.format_cep(@xml['enderEntrega/cMun'])
        end

        def render_line3
          @pdf.lbox LINE_HEIGHT, 6.61, 0.75, @l3, @xml, 'enderEntrega/xMun'
          @pdf.i18n_lbox LINE_HEIGHT, 4.06, 7.36, @l3, 'enderDest.fone', phone
          @pdf.lbox LINE_HEIGHT, 1.14, 11.42, @l3, @xml, 'enderEntrega/UF'
          @pdf.lie LINE_HEIGHT, 4.38, 12.56, @l3, @xml, 'enderEntrega/UF', 'dest/IE'
        end

        def phone
          Phone.format(@xml['enderDest/fone'])
        end
      end
    end
  end
end
