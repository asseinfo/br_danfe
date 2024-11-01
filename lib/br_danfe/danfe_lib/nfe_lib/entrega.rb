module BrDanfe
  module DanfeLib
    module NfeLib
      class Entrega
        Y_POSITION = 12.92
        MAXIMUM_SIZE_FOR_STREET = 319

        def initialize(pdf, xml)
          @pdf = pdf
          @xml = xml

          @y_position = Y_POSITION
          @address = 'entrega/xLgr'

          @ltitle = @y_position - 0.42
          @l1 = @y_position
          @l2 = @y_position + LINE_HEIGHT
          @l3 = @y_position + (LINE_HEIGHT * 2)
        end

        def render
          if Entrega.delivery_local?(@xml)
            @pdf.ititle 0.42, 10.00, 0.75, @ltitle, 'entrega.title'
            render_line1
            render_line2
            render_line3
          end
        end

        def self.delivery_local?(xml)
          doc = xml.is_a?(BrDanfe::XML) ? xml : Nokogiri::XML(xml)
          doc.css('entrega/xLgr').text.present?
        end

        private

        def render_line1
          @pdf.lbox LINE_HEIGHT, 11.82, 0.75, @l1, @xml, 'entrega/xNome'
          render_cnpj_cpf
          @pdf.lie LINE_HEIGHT, 2.92, 17.40, @l1, @xml, 'entrega/UF', 'entrega/IE'
        end

        def render_cnpj_cpf
          if @xml['entrega/CNPJ'] == ''
            @pdf.i18n_lbox LINE_HEIGHT, 4.37, 12.57, @l1, 'entrega.CPF', cpf
          else
            @pdf.lcnpj LINE_HEIGHT, 4.37, 12.57, @l1, @xml, 'entrega/CNPJ'
          end
        end

        def cpf
          cpf = BrDocuments::CnpjCpf::Cpf.new(@xml['entrega/CPF'])
          cpf.formatted
        end

        def render_line2
          @pdf.i18n_lbox LINE_HEIGHT, 11.82, 0.75, @l2, 'entrega.xLgr', address
          @pdf.lbox LINE_HEIGHT, 4.37, 12.57, @l2, @xml, 'entrega/xBairro'
          @pdf.i18n_lbox LINE_HEIGHT, 2.92, 17.40, @l2, 'entrega.CEP', cep
        end

        def address
          address = Helper.generate_address @xml, 'entrega'

          if Helper.address_is_too_big(@pdf, address)
            address = address[0..address.length - 2] while Helper.mensure_text(@pdf, "#{address.strip}...") > MAXIMUM_SIZE_FOR_STREET && !address.empty?
            address = "#{address.strip}..."
          end
          address
        end

        def cep
          BrDanfe::Helper.format_cep(@xml['entrega/CEP'])
        end

        def render_line3
          @pdf.lbox LINE_HEIGHT, 15.05, 0.75, @l3, @xml, 'entrega/xMun'
          @pdf.lbox LINE_HEIGHT, 1.14, 15.8, @l3, @xml, 'entrega/UF'
          @pdf.i18n_lbox LINE_HEIGHT, 2.92, 17.40, @l3, 'entrega.fone', phone
        end

        def phone
          Phone.format(@xml['entrega/fone'])
        end
      end
    end
  end
end
