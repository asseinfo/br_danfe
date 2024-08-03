module BrDanfe
  module DanfeLib
    class Base
      attr_reader :options

      def initialize(xmls)
        @xmls = group_xmls(xmls)
        @document = document
        @options = BrDanfe::Logo::Config.new

        create_watermark
      end

      def save_pdf(filename, footer_info = '')
        generate footer_info
        @document.render_file filename
      end

      def render_pdf(footer_info = '')
        generate footer_info
        @document.render
      end

      private

      def document; end

      def create_watermark; end

      def generate(footer_info); end

      def group_xmls(xmls)
        xml_list = {}

        xmls.each do |xml|
          is_event = BrDanfe::Helper.event?(xml)
          xml_key = is_event ? xml['evento > infEvento > chNFe'] : xml.css('infNFe').attr('Id').to_s.gsub(/[^\d]/, '')

          xml_list[xml_key] ||= { xml: nil, events: [] }
          xml_list[xml_key][:xml] = xml unless is_event
          xml_list[xml_key][:events] << xml if is_event
        end

        filter_xml_list(xml_list)
      end

      def filter_xml_list(xml_list)
        xml_list.reject { |_key, data| data[:xml].nil? }
                .map { |_key, data| [data[:xml], data[:events]] }
      end
    end
  end
end
