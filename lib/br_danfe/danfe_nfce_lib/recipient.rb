module BrDanfe
  module DanfeNfceLib
    class Recipient
      LINE_HEIGHT = 1.35

      def initialize(pdf, xml)
        @pdf = pdf
        @xml = xml
      end

      def render
        @pdf.y -= 0.6.cm
        BrDanfe::DanfeNfceLib::Helper.homologation?(@xml) ? render_homologation : render_recipient
      end

      private

      def render_homologation
        @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'EMITIDA EM AMBIENTE DE HOMOLOGAÇÃO – SEM VALOR FISCAL', { size: 7, align: :center, border: 0, style: :bold }
      end

      def render_recipient
        if identified_recipient?
          render_document

          @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', @xml['dest/xNome'], { size: 7, align: :center, border: 0 }
          @pdf.y -= 0.6.cm
          @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', address, { size: 7, align: :center, border: 0 }
        else
          @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', 'CONSUMIDOR NÃO IDENTIFICADO', { size: 7, align: :center, border: 0, style: :bold }
        end
      end

      def identified_recipient?
        @xml['dest/xNome'].present?
      end

      def render_document
        document_text = document
        if document_text.present?
          @pdf.ibox LINE_HEIGHT, 7.4, 0, @pdf.cursor, '', document, { size: 7, align: :center, border: 0 }
          @pdf.y -= 0.3.cm
        end
      end

      def document
        return company if company?
        return individual if individual?
        return foreign if foreign?
        return ''
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

      def address
        "#{@xml['enderDest/xLgr']}, #{@xml['enderDest/nro']}, #{@xml['enderDest/xBairro']}, #{@xml['enderDest/xMun']} - #{@xml['enderDest/UF']}"
      end

      # def test(text, options)
      #   text_width = @pdf.width_of text, options
        # FIXME: resolver depois o tamanho do endereço
        # nessa refatoração, criar um método que saiba imprimir um texto, passando somente o X e o texto,
        # já haveria as options defaults, fonte etc
        # nesse metodo, ele sempre imprime o texto e já deixa o cursor na posição correta (ex @pdf.y -= 0.3.cm)
        # se o texto for maior que o espaço, ele imprime com quebra de linha, e posiciona o cursor abaixo da quebra...

        # no caso acima (nome e endereço, ver se depois desse método pronto, não ficará melhor imprimir um do lado do outro nome - endereço)
      # end
    end
  end
end
