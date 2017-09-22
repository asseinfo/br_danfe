require "spec_helper"

describe BrDanfe::DanfeLib::Helper do
  describe ".numerify" do
    it "formats with the decimals" do
      expect(BrDanfe::DanfeLib::Helper.numerify(0.123)).to eq "0,123"
      expect(BrDanfe::DanfeLib::Helper.numerify(0.1234)).to eq "0,1234"
      expect(BrDanfe::DanfeLib::Helper.numerify(0.12345)).to eq "0,12345"
      expect(BrDanfe::DanfeLib::Helper.numerify(0.1234567891)).to eq "0,1234567891"
    end

    it "formats integers" do
      expect(BrDanfe::DanfeLib::Helper.numerify(100)).to eq "100,00"
    end

    it "formats decimals" do
      expect(BrDanfe::DanfeLib::Helper.numerify(123.45)).to eq "123,45"
    end

    it "formats thousands" do
      expect(BrDanfe::DanfeLib::Helper.numerify(1000)).to eq "1.000,00"
    end

    it "formats millions" do
      expect(BrDanfe::DanfeLib::Helper.numerify(1000000)).to eq "1.000.000,00"
    end

    it "formats using two as min decimal precision" do
      expect(BrDanfe::DanfeLib::Helper.numerify(123.4)).to eq "123,40"
    end

    it "formats 0 to 0,00" do
      expect(BrDanfe::DanfeLib::Helper.numerify(0)).to eq "0,00"
    end

    it "doesn't format nil value" do
      expect(BrDanfe::DanfeLib::Helper.numerify(nil)).to eq ""
    end

    it "doesn't format blank value" do
      expect(BrDanfe::DanfeLib::Helper.numerify("")).to eq ""
    end
  end

  describe ".format_datetime" do
    it "returns a formated string" do
      string = "2013-10-18T13:54:04"
      expect(BrDanfe::DanfeLib::Helper.format_datetime(string)).to eq "18/10/2013 13:54:04"
    end

    describe "when the source is blank" do
      it "is empty" do
        expect(BrDanfe::DanfeLib::Helper.format_datetime("")).to eq ""
      end
    end
  end

  describe ".format_date" do
    it "returns a formated string" do
      string = "2013-10-18T13:54:04"
      expect(BrDanfe::DanfeLib::Helper.format_date(string)).to eq "18/10/2013"
    end

    describe "when the source is blank" do
      it "is empty" do
        expect(BrDanfe::DanfeLib::Helper.format_date("")).to eq ""
      end
    end
  end

  describe ".format_time" do
    describe "when param is a complete datetime" do
      let(:param) { "2013-10-18T16:54:04-03:00" }

      it "is a formated time string in localtime" do
        expect(BrDanfe::DanfeLib::Helper.format_time(param)).to eq "16:54:04"
      end
    end

    describe "when param is only a time" do
      let(:param) { "14:23:02" }

      it "is a formated time string" do
        expect(BrDanfe::DanfeLib::Helper.format_time(param)).to eq "14:23:02"
      end
    end

    describe "when param is blank" do
      let(:param) { "" }

      it "is empty" do
        expect(BrDanfe::DanfeLib::Helper.format_time(param)).to eq ""
      end
    end
  end

  describe ".no_fiscal_value?" do
    let(:xml_homologation) do
      xml = <<-eos
        <nfeProc>
          <NFe>
            <infNFe>
              <ide>
                <tpAmb>2</tpAmb>
              </ide>
            </infNFe>
            <protNFe>
              <infProt>
                <dhRecbto>2011-10-29T14:37:09</dhRecbto>
              </infProt>
            </protNFe>
          </NFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    let(:xml_unauthorized) do
      xml = <<-eos
        <nfeProc>
          <protNFe>
            <infProt></infProt>
          </protNFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    let(:xml_authorized) do
      xml = <<-eos
        <nfeProc>
          <NFe>
            <infNFe>
              <ide>
                <tpAmb>1</tpAmb>
              </ide>
            </infNFe>
          </NFe>
          <protNFe>
            <infProt>
              <dhRecbto>2011-10-29T14:37:09</dhRecbto>
            </infProt>
          </protNFe>
        </nfeProc>
      eos

      Nokogiri::XML(xml)
    end

    context "when XML is unauthorized" do
      it "returns true" do
        expect(BrDanfe::DanfeLib::Helper.has_no_fiscal_value?(xml_unauthorized)).to eq true
      end
    end

    context "when XML is in homologation environment" do
      it "returns true" do
        expect(BrDanfe::DanfeLib::Helper.has_no_fiscal_value?(xml_homologation)).to eq true
      end
    end

    context "when XML is authorized" do
      it "returns false" do
        expect(BrDanfe::DanfeLib::Helper.has_no_fiscal_value?(xml_authorized)).to eq false
      end
    end
  end

  describe ".address_is_too_big" do
    let(:pdf) { BrDanfe::DanfeLib::Document.new }

    context "when the address is too big for the street field at DANFE" do
      let(:address) { "Rua do governo do estado 1125 - Em anexo ao super mercado maior do bairro" }

      it "returns true" do
        expect(BrDanfe::DanfeLib::Helper.address_is_too_big(pdf, address)).to be true
      end
    end

    context "when the address fits in the street field in DANFE" do
      let(:address) { "Rua do governo do estado 1125 - Salas 1 e 2" }

      it "returns false" do
        expect(BrDanfe::DanfeLib::Helper.address_is_too_big(pdf, address)).to be false
      end
    end
  end

  describe ".generate_address" do
    let(:xml) do
      <<-eos
        <enderDest>
          <xLgr>Rua do governo do estado</xLgr>
          <nro>1125</nro>
          <xCpl>Em anexo ao super mercado maior do bairro</xCpl>
        </enderDest>
      eos
    end

    let(:xml_street) do
      Nokogiri::XML(xml)
    end

    it "joins street, number and complement" do
      expect(BrDanfe::DanfeLib::Helper.generate_address(xml_street))
        .to eq "Rua do governo do estado 1125 - Em anexo ao super mercado maior do bairro"
    end

    context "when receipient address hasn't complement" do
      let(:xml) do
        <<-eos
        <enderDest>
          <xLgr>Rua do governo do estado</xLgr>
          <nro>1125</nro>
          <xCpl></xCpl>
        </enderDest>
        eos
      end

      it "joins only street and number" do
        expect(BrDanfe::DanfeLib::Helper.generate_address(xml_street))
          .to eq "Rua do governo do estado 1125"
      end
    end

    context "when receipient address hasn't complement and number" do
      let(:xml) do
        <<-eos
        <enderDest>
          <xLgr>Rua do governo do estado</xLgr>
          <nro></nro>
          <xCpl></xCpl>
        </enderDest>
        eos
      end

      it "joins only street" do
        expect(BrDanfe::DanfeLib::Helper.generate_address(xml_street))
          .to eq "Rua do governo do estado"
      end
    end
  end
end
