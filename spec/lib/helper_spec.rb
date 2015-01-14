require "spec_helper"

describe BrDanfe::Helper do
  describe ".format_datetime" do
    it "returns a formated string" do
      string = "2013-10-18T13:54:04"
      expect(BrDanfe::Helper.format_datetime(string)).to eq "18/10/2013 13:54:04"
    end

    describe "when the source is blank" do
      it "is empty" do
        expect(BrDanfe::Helper.format_datetime("")).to eq ""
      end
    end
  end

  describe ".format_date" do
    it "returns a formated string" do
      string = "2013-10-18T13:54:04"
      expect(BrDanfe::Helper.format_date(string)).to eq "18/10/2013"
    end

    describe "when the source is blank" do
      it "is empty" do
        expect(BrDanfe::Helper.format_date("")).to eq ""
      end
    end
  end

  describe ".format_time" do
    describe "when param is a complete datetime" do
      let(:param) { "2013-10-18T16:54:04-03:00" }

      it "is a formated time string in UTC" do
        expect(BrDanfe::Helper.format_time(param)).to eq "19:54:04"
      end
    end

    describe "when param is only a time" do
      let(:param) { "14:23:02" }

      it "is a formated time string" do
        expect(BrDanfe::Helper.format_time(param)).to eq "14:23:02"
      end
    end

    describe "when param is blank" do
      let(:param) { "" }

      it "is empty" do
        expect(BrDanfe::Helper.format_time(param)).to eq ""
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
        expect(BrDanfe::Helper.has_no_fiscal_value?(xml_unauthorized)).to eq true
      end
    end

    context "when XML is in homologation environment" do
      it "returns true" do
        expect(BrDanfe::Helper.has_no_fiscal_value?(xml_homologation)).to eq true
      end
    end

    context "when XML is authorized" do
      it "returns false" do
        expect(BrDanfe::Helper.has_no_fiscal_value?(xml_authorized)).to eq false
      end
    end
  end
end
