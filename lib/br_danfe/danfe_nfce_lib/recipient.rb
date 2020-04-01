module BrDanfe
  module DanfeNfceLib
    class Recipient
      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        @pdf.render_blank_line

        if identified_recipient?
          render_document

          @pdf.text @xml['dest/xNome'], options
          @pdf.text BrDanfe::DanfeNfceLib::Helper.address(@xml.css('enderDest')), options
        else
          @pdf.text 'CONSUMIDOR NÃO IDENTIFICADO', options
        end
      end

      private

      def options
        { size: 7, align: :center }
      end

      def identified_recipient?
        @xml['dest/xNome'].present?
      end

      def render_document
        document_text = document

        @pdf.text document_text, options if document_text.present?
      end

      def document
        return company if company?
        return individual if individual?
        return foreign if foreign?

        ''
      end

      def company?
        @xml['dest/CNPJ'].present?
      end

      def company
        cnpj = BrDocuments::CnpjCpf::Cnpj.new @xml['dest/CNPJ']
        "CONSUMIDOR CNPJ: #{cnpj.formatted}"
      end

      def individual?
        @xml['dest/CPF'].present?
      end

      def individual
        cpf = BrDocuments::CnpjCpf::Cpf.new(@xml['dest/CPF'])
        "CONSUMIDOR CPF: #{cpf.formatted}"
      end

      def foreign?
        @xml['dest/idEstrangeiro'].present?
      end

      def foreign
        "CONSUMIDOR Id. Estrangeiro: #{@xml['dest/idEstrangeiro']}"
      end
    end
  end
end
