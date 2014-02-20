module RubyDanfe
  class Icmstot
    def self.render(pdf, xml)
      pdf.ititle 0.42, 5.60, 0.25, 12.36, "ICMSTot.title"

      pdf.lnumeric 0.85, 4.06, 0.25, 12.78, xml, "ICMSTot/vBC"
      pdf.lnumeric 0.85, 4.06, 4.31, 12.78, xml, "ICMSTot/vICMS"
      pdf.lnumeric 0.85, 4.06, 8.37, 12.78, xml, "ICMSTot/vBCST"
      pdf.lnumeric 0.85, 4.06, 12.43, 12.78, xml, "ICMSTot/vST"
      pdf.lnumeric 0.85, 4.32, 16.49, 12.78, xml, "ICMSTot/vProd"
      pdf.lnumeric 0.85, 3.46, 0.25, 13.63, xml, "ICMSTot/vFrete"
      pdf.lnumeric 0.85, 3.46, 3.71, 13.63, xml, "ICMSTot/vSeg"
      pdf.lnumeric 0.85, 3.46, 7.17, 13.63, xml, "ICMSTot/vDesc"
      pdf.lnumeric 0.85, 3.46, 10.63, 13.63, xml, "ICMSTot/vOutro"
      pdf.lnumeric 0.85, 3.46, 14.09, 13.63, xml, "ICMSTot/vIPI"
      pdf.lnumeric 0.85, 3.27, 17.55, 13.63, xml, "ICMSTot/vNF", style: :bold
    end
  end
end
