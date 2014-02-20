module RubyDanfe
  class DanfeGenerator
    def initialize(xml)
      @xml = xml
      @pdf = Document.new
      @vol = 0
      @logo_path = RubyDanfe.options.logo_path

      @pdf.create_stamp("sem_valor_fiscal") do
        @pdf.fill_color "7d7d7d"
        @pdf.text_box I18n.t("danfe.others.without_fiscal_value"),
          size: 2.2.cm,
          width: @pdf.bounds.width,
          height: @pdf.bounds.height,
          align: :center,
          valign: :center,
          at: [0, @pdf.bounds.height],
          rotate: 45,
          rotate_around: :center
      end
    end

    def generatePDF
      @pdf.stamp("sem_valor_fiscal") if Helper.without_fiscal_value?(@xml)

      @pdf.repeat :all do
        render_canhoto
        render_emitente
        render_titulo
        render_faturas
        render_calculo_do_imposto
        render_transportadora_e_volumes
        render_cabecalho_dos_produtos
        render_calculo_do_issqn
        render_dados_adicionais
      end

      render_produtos

      @pdf.page_count.times do |i|
        @pdf.go_to_page(i + 1)
        @pdf.ibox 1.00, 2.08, 8.71, 5.54, "",
          I18n.t("danfe.others.page", current: i+1, total: @pdf.page_count),
          {size: 8, align: :center, valign: :center, border: 0, style: :bold}
      end

      @pdf
    end

    private
    def render_canhoto
      @pdf.ibox 0.85, 16.10, 0.25, 0.42, I18n.t("danfe.ticket.xNome", xNome: @xml["emit/xNome"])
      @pdf.ibox 0.85, 4.10, 0.25, 1.27, I18n.t("danfe.ticket.received_at")
      @pdf.ibox 0.85, 12.00, 4.35, 1.27, I18n.t("danfe.ticket.receiver")
      @pdf.ibox 1.70, 4.50, 16.35, 0.42, "", I18n.t("danfe.ticket.document", nNF: @xml["ide/nNF"], serie: @xml["ide/serie"]), {align: :center, valign: :center}
    end

    def render_emitente

      if @logo_path.empty?
        @pdf.ibox 3.92, 8.46, 0.25, 2.80, "", @xml["emit/xNome"], {size: 12, align: :center, border: 0, style: :bold}
        @pdf.ibox 3.92, 8.46, 0.25, 2.54, "",
          "\n" + @xml["enderEmit/xLgr"] + ", " + @xml["enderEmit/nro"] + "\n" +
          @xml["enderEmit/xBairro"] + " - " + Cep.format(@xml["enderEmit/CEP"]) + "\n" +
          @xml["enderEmit/xMun"] + "/" + @xml["enderEmit/UF"] + "\n" +
          Phone.format(@xml["enderEmit/fone"]) + " " + @xml["enderEmit/email"], {align: :center, valign: :center}
      else
        @pdf.ibox 3.92, 8.46, 0.25, 2.54
        @pdf.ibox 3.92, 8.46, 0.25, 2.80, "", @xml["emit/xNome"], {size: 12, align: :center, border: 0, style: :bold}
        @pdf.ibox 3.92, 8.46, 2.75, 4, "",
          @xml["enderEmit/xLgr"] + ", " + @xml["enderEmit/nro"] + "\n" +
          @xml["enderEmit/xBairro"] + " - " + Cep.format(@xml["enderEmit/CEP"]) + "\n" +
          @xml["enderEmit/xMun"] + "/" + @xml["enderEmit/UF"] + "\n" +
          Phone.format(@xml["enderEmit/fone"]) + " " + @xml["enderEmit/email"], {size: 8, align: :left, border: 0, style: :bold}
        @pdf.image @logo_path, at: [0.5.cm, Helper.invert(4.cm)], width: 2.cm
      end

      @pdf.ibox 3.92, 2.08, 8.71, 2.54

      @pdf.ibox 0.60, 2.08, 8.71, 2.54, "", "DANFE", {size: 12, align: :center, border: 0, style: :bold}
      @pdf.ibox 1.20, 2.08, 8.71, 3.14, "", I18n.t("danfe.others.danfe"), {size: 8, align: :center, border: 0}
      @pdf.ibox 0.60, 2.08, 8.71, 4.34, "", "#{@xml['ide/tpNF']} - " + (@xml["ide/tpNF"] == "0" ? I18n.t("danfe.ide.tpNF.entry") : I18n.t("danfe.ide.tpNF.departure")), {size: 8, align: :center, border: 0}

      @pdf.ibox 1.00, 2.08, 8.71, 4.94, "",
        I18n.t("danfe.ide.document", nNF: @xml["ide/nNF"], serie: @xml["ide/serie"]), {size: 8, align: :center, valign: :center, border: 0, style: :bold}

      @pdf.ibox 2.20, 10.02, 10.79, 2.54
      @pdf.ibarcode 1.50, 8.00, 10.9010, 4.44, @xml["chNFe"]
      @pdf.ibox 0.85, 10.02, 10.79, 4.74, I18n.t("danfe.chNFe"), @xml["chNFe"].gsub(/(\d)(?=(\d\d\d\d)+(?!\d))/, "\\1 "), {style: :bold, align: :center}
      @pdf.ibox 0.85, 10.02, 10.79, 5.60 , "", I18n.t("danfe.others.sefaz"), {align: :center, size: 8}
      @pdf.lbox 0.85, 10.54, 0.25, 6.46, @xml, "ide/natOp"
      @pdf.ibox 0.85, 10.02, 10.79, 6.46, I18n.t("danfe.infProt"), @xml["infProt/nProt"] + " " + Helper.format_date(@xml["infProt/dhRecbto"]) , {align: :center}

      @pdf.ibox 0.85, 6.86, 0.25, 7.31, I18n.t("danfe.emit.IE"), Ie.format(@xml["emit/IE"], @xml["enderEmit/UF"])
      @pdf.ibox 0.85, 6.86, 7.11, 7.31, I18n.t("danfe.emit.IE_ST"), Ie.format(@xml["emit/IE_ST"], @xml["enderEmit/UF"])
      @pdf.ibox 0.85, 6.84, 13.97, 7.31, I18n.t("danfe.emit.CNPJ"), Cnpj.format(@xml["emit/CNPJ"])
    end

    def render_titulo
      @pdf.ititle 0.42, 10.00, 0.25, 8.16, "dest.title"

      @pdf.lbox 0.85, 12.32, 0.25, 8.58, @xml, "dest/xNome"
      @pdf.ibox 0.85, 5.33, 12.57, 8.58, I18n.t("danfe.dest.CNPJ"), Cnpj.format(@xml["dest/CNPJ"])  if @xml["dest/CNPJ"] != ""
      @pdf.ibox 0.85, 5.33, 12.57, 8.58, I18n.t("danfe.dest.CPF"), Cpf.format(@xml["dest/CPF"]) if @xml["dest/CPF"] != ""
      @pdf.idate 0.85, 2.92, 17.90, 8.58, "ide.dEmi", @xml["ide/dEmi"], {align: :right}
      @pdf.ibox 0.85, 10.16, 0.25, 9.43, I18n.t("danfe.enderDest.xLgr"), @xml["enderDest/xLgr"] + " " + @xml["enderDest/nro"]
      @pdf.lbox 0.85, 4.83, 10.41, 9.43, @xml, "enderDest/xBairro"
      @pdf.ibox 0.85, 2.67, 15.24, 9.43, I18n.t("danfe.enderDest.CEP"), Cep.format(@xml["enderDest/CEP"])
      @pdf.idate 0.85, 2.92, 17.90, 9.43, "ide.dSaiEnt", @xml["ide/dSaiEnt"], {align: :right}
      @pdf.lbox 0.85, 7.11, 0.25, 10.28, @xml, "enderDest/xMun"
      @pdf.ibox 0.85, 4.06, 7.36, 10.28, I18n.t("danfe.enderDest.fone"), Phone.format(@xml["enderDest/fone"])
      @pdf.lbox 0.85, 1.14, 11.42, 10.28, @xml, "enderDest/UF"
      @pdf.ibox 0.85, 5.33, 12.56, 10.28, I18n.t("danfe.dest.IE"), Ie.format(@xml["dest/IE"], @xml["enderDest/UF"])
      @pdf.idate 0.85, 2.92, 17.90, 10.28, "ide.hSaiEnt", @xml["ide/dSaiEnt"], {align: :right}
    end

    def render_faturas
      @pdf.ititle 0.42, 10.00, 0.25, 11.12, "dup.title"
      @pdf.ibox 0.85, 20.57, 0.25, 11.51

      x = 0.25
      y = 11.51
      @xml.collect("xmlns", "dup") do |det|
        @pdf.ibox 0.85, 2.12, x, y, "", I18n.t("danfe.dup.nDup"), { size: 6, border: 0, style: :italic }
        @pdf.ibox 0.85, 2.12, x + 0.70, y, "", det.css("nDup").text, { size: 6, border: 0 }
        @pdf.ibox 0.85, 2.12, x, y + 0.20, "", I18n.t("danfe.dup.dVenc"), { size: 6, border: 0, style: :italic }
        dtduplicata = det.css("dVenc").text
        dtduplicata = dtduplicata[8,2] + "/" + dtduplicata[5, 2] + "/" + dtduplicata[0, 4]
        @pdf.ibox 0.85, 2.12, x + 0.70, y + 0.20, "", dtduplicata, { size: 6, border: 0 }
        @pdf.ibox 0.85, 2.12, x, y + 0.40, "", I18n.t("danfe.dup.vDup"), { size: 6, border: 0, style: :italic }
        @pdf.inumeric 0.85, 1.25, x + 0.70, y + 0.40, "", det.css("vDup").text, { size: 6, border: 0 }
        x = x + 2.30
      end
    end

    def render_calculo_do_imposto
      @pdf.ititle 0.42, 5.60, 0.25, 12.36, "ICMSTot.title"

      @pdf.lnumeric 0.85, 4.06, 0.25, 12.78, @xml, "ICMSTot/vBC"
      @pdf.lnumeric 0.85, 4.06, 4.31, 12.78, @xml, "ICMSTot/vICMS"
      @pdf.lnumeric 0.85, 4.06, 8.37, 12.78, @xml, "ICMSTot/vBCST"
      @pdf.lnumeric 0.85, 4.06, 12.43, 12.78, @xml, "ICMSTot/vST"
      @pdf.lnumeric 0.85, 4.32, 16.49, 12.78, @xml, "ICMSTot/vProd"
      @pdf.lnumeric 0.85, 3.46, 0.25, 13.63, @xml, "ICMSTot/vFrete"
      @pdf.lnumeric 0.85, 3.46, 3.71, 13.63, @xml, "ICMSTot/vSeg"
      @pdf.lnumeric 0.85, 3.46, 7.17, 13.63, @xml, "ICMSTot/vDesc"
      @pdf.lnumeric 0.85, 3.46, 10.63, 13.63, @xml, "ICMSTot/vOutro"
      @pdf.lnumeric 0.85, 3.46, 14.09, 13.63, @xml, "ICMSTot/vIPI"
      @pdf.lnumeric 0.85, 3.27, 17.55, 13.63, @xml, "ICMSTot/vNF", style: :bold
    end

    def render_transportadora_e_volumes
      @pdf.ititle 0.42, 10.00, 0.25, 14.48, "transporta.title"

      @pdf.lbox 0.85, 9.02, 0.25, 14.90, @xml, "transporta/xNome"
      @pdf.ibox 0.85, 2.79, 9.27, 14.90, I18n.t("danfe.transp.modFrete.title"), @xml["transp/modFrete"] == "0" ? I18n.t("danfe.transp.modFrete.emitter") : I18n.t("danfe.transp.modFrete.recipient")
      @pdf.lbox 0.85, 1.78, 12.06, 14.90, @xml, "veicTransp/RNTC"
      @pdf.ibox 0.85, 2.29, 13.84, 14.90, I18n.t("danfe.veicTransp.placa"), Plate.format(@xml["veicTransp/placa"])
      @pdf.lbox 0.85, 0.76, 16.13, 14.90, @xml, "veicTransp/UF"
      @pdf.lbox 0.85, 3.94, 16.89, 14.90, @xml, "transporta/CNPJ"
      @pdf.lbox 0.85, 9.02, 0.25, 15.75, @xml, "transporta/xEnder"
      @pdf.lbox 0.85, 6.86, 9.27, 15.75, @xml, "transporta/xMun"
      @pdf.lbox 0.85, 0.76, 16.13, 15.75, @xml, "transporta/UF"
      @pdf.lbox 0.85, 3.94, 16.89, 15.75, @xml, "transporta/IE"

      @vol = 0
      @xml.collect("xmlns", "vol") do |det|
        @vol += 1
        if @vol < 2
          @pdf.ibox 0.85, 2.92, 0.25, 16.60, I18n.t("danfe.vol.qVol"), det.css("qVol").text
          @pdf.ibox 0.85, 3.05, 3.17, 16.60, I18n.t("danfe.vol.esp"), det.css("esp").text
          @pdf.ibox 0.85, 3.05, 6.22, 16.60, I18n.t("danfe.vol.marca"), det.css("marca").text
          @pdf.ibox 0.85, 4.83, 9.27, 16.60, I18n.t("danfe.vol.nVol")
          @pdf.inumeric 0.85, 3.43, 14.10, 16.60, "vol.pesoB", det.css("pesoB").text, {decimals: 3}
          @pdf.inumeric 0.85, 3.30, 17.53, 16.60, "vol.pesoL", det.css("pesoL").text, {decimals: 3}
        else
          break
        end
      end
    end

    def render_cabecalho_dos_produtos
      @pdf.ititle 0.42, 10.00, 0.25, 17.45, "det.title"

      @pdf.ibox 6.70, 2.00, 0.25, 17.87, I18n.t("danfe.det.prod.cProd")
      @pdf.ibox 6.70, 4.90, 2.25, 17.87, I18n.t("danfe.det.prod.xProd")
      @pdf.ibox 6.70, 1.30, 7.15, 17.87, I18n.t("danfe.det.prod.NCM")
      @pdf.ibox 6.70, 0.80, 8.45, 17.87, I18n.t("danfe.det.ICMS.CST")
      @pdf.ibox 6.70, 1.00, 9.25, 17.87, I18n.t("danfe.det.prod.CFOP")
      @pdf.ibox 6.70, 1.00, 10.25, 17.87, I18n.t("danfe.det.prod.uCom")
      @pdf.ibox 6.70, 1.30, 11.25, 17.87, I18n.t("danfe.det.prod.qCom")
      @pdf.ibox 6.70, 1.50, 12.55, 17.87, I18n.t("danfe.det.prod.vUnCom")
      @pdf.ibox 6.70, 1.50, 14.05, 17.87, I18n.t("danfe.det.prod.vProd")
      @pdf.ibox 6.70, 1.50, 15.55, 17.87, I18n.t("danfe.det.ICMS.vBC")
      @pdf.ibox 6.70, 1.00, 17.05, 17.87, I18n.t("danfe.det.ICMS.vICMS")
      @pdf.ibox 6.70, 1.00, 18.05, 17.87, I18n.t("danfe.det.IPI.vIPI")
      @pdf.ibox 6.70, 0.90, 19.05, 17.87, I18n.t("danfe.det.ICMS.pICMS")
      @pdf.ibox 6.70, 0.86, 19.95, 17.87, I18n.t("danfe.det.IPI.pIPI")

      @pdf.horizontal_line 0.25.cm, 20.83.cm, at: Helper.invert(18.17.cm)
    end

    def render_calculo_do_issqn
      @pdf.ititle 0.42, 10.00, 0.25, 24.64, "issqn.title"

      @pdf.lbox 0.85, 5.08, 0.25, 25.06, @xml, "emit/IM"
      @pdf.lbox 0.85, 5.08, 5.33, 25.06, @xml, "total/vServ"
      @pdf.lbox 0.85, 5.08, 10.41, 25.06, @xml, "total/vBCISS"
      @pdf.lbox 0.85, 5.28, 15.49, 25.06, @xml, "total/ISSTot"
    end

    def render_dados_adicionais
      @pdf.ititle 0.42, 10.00, 0.25, 25.91, "infAdic.title"

      if @vol > 1
        @pdf.ibox 3.07, 12.93, 0.25, 26.33, I18n.t("danfe.infAdic.infCpl"), "", {size: 8, valign: :top}
        @pdf.ibox 3.07, 12.93, 0.25, 26.60, "", I18n.t("danfe.infAdic.vol.title"), {size: 5, valign: :top, border: 0}
        v = 0
        y = 26.67
        @xml.collect("xmlns", "vol") do |det|
          v += 1
          if v > 1
            @pdf.ibox 0.35, 0.70, 0.25, y + 0.10, "", I18n.t("danfe.infAdic.vol.qVol"), { size: 4, border: 0 }
            @pdf.ibox 0.35, 0.70, 0.90, y + 0.10, "", det.css("qVol").text, { size: 4, border: 0, style: :italic }
            @pdf.ibox 0.35, 0.50, 1.35, y + 0.10, "", I18n.t("danfe.infAdic.vol.esp"), { size: 4, border: 0 }
            @pdf.ibox 0.35, 3.00, 1.75, y + 0.10, "", det.css("esp").text, { size: 4, border: 0, style: :italic }
            @pdf.ibox 0.35, 0.70, 4.15, y + 0.10, "", I18n.t("danfe.infAdic.vol.marca"), { size: 4, border: 0 }
            @pdf.ibox 0.35, 2.00, 4.75, y + 0.10, "", det.css("marca").text, { size: 4, border: 0, style: :italic }
            @pdf.ibox 0.35, 1.00, 6.10, y + 0.10, "", I18n.t("danfe.infAdic.vol.nVol"),  { size: 4, border: 0 }
            @pdf.ibox 0.35, 1.30, 7.00, y + 0.10, "", I18n.t("danfe.infAdic.vol.pesoB"), { size: 4, border: 0 }
            @pdf.inumeric 0.35, 1.30, 7.00, y + 0.10, "", det.css("pesoB").text, {decimals: 3, size: 4, border: 0, style: :italic }
            @pdf.ibox 0.35, 0.90, 8.50, y + 0.10, "", I18n.t("danfe.infAdic.vol.pesoL"), { size: 4, border: 0 }
            @pdf.inumeric 0.35, 1.50, 8.50, y + 0.10, "", det.css("pesoL").text, {decimals: 3, size: 4, border: 0, style: :italic }
            y = y + 0.15
          end
        end
        @pdf.ibox 2.07, 12.93, 0.25, y + 0.30, "", I18n.t("danfe.infAdic.others"), {size: 6, valign: :top, border: 0}
        @pdf.ibox 2.07, 12.93, 0.25, y + 0.50, "", @xml["infAdic/infCpl"], {size: 5, valign: :top, border: 0}
      else
         @pdf.ibox 3.07, 12.93, 0.25, 26.33, I18n.t("danfe.infAdic.infCpl"), @xml["infAdic/infCpl"], {size: 6, valign: :top}
      end

      @pdf.ibox 3.07, 7.62, 13.17, 26.33, I18n.t("danfe.infAdic.reserved")
    end

    def render_produtos
      @pdf.font_size(6) do
        @pdf.itable 6.37, 21.50, 0.25, 18.17,
          @xml.collect("xmlns", "det")  { |det|
            [
              det.css("prod/cProd").text, #I02
              Descricao.generate(det), #I04
              det.css("prod/NCM").text, #I05
              Cst.to_danfe(det), #N11
              det.css("prod/CFOP").text, #I08
              det.css("prod/uCom").text, #I09
              Helper.numerify(det.css("prod/qCom").text), #I10
              Helper.numerify(det.css("prod/vUnCom").text), #I10a
              Helper.numerify(det.css("prod/vProd").text), #I11
              Helper.numerify(det.css("ICMS/*/vBC").text), #N15
              Helper.numerify(det.css("ICMS/*/vICMS").text), #N17
              Helper.numerify(det.css("IPI/*/vIPI").text), #O14
              Helper.numerify(det.css("ICMS/*/pICMS").text), #N16
              Helper.numerify(det.css("IPI/*/pIPI").text) #O13
            ]
          },
          column_widths: {
            0 => 2.00.cm,
            1 => 4.90.cm,
            2 => 1.30.cm,
            3 => 0.80.cm,
            4 => 1.00.cm,
            5 => 1.00.cm,
            6 => 1.30.cm,
            7 => 1.50.cm,
            8 => 1.50.cm,
            9 => 1.50.cm,
            10 => 1.00.cm,
            11 => 1.00.cm,
            12 => 0.90.cm,
            13 => 0.86.cm
          },
          cell_style: {padding: 2, border_width: 0} do |table|
            table.column(6..13).style(align: :right)
            table.column(0..13).border_width = 1
            table.column(0..13).borders = [:bottom]
          end
      end
    end
  end
end
