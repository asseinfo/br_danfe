require "prawn"
require "prawn/measurement_extensions"
require "barby"
require "barby/barcode/code_128"
require "barby/outputter/prawn_outputter"
require "nokogiri"
require "yaml"
require "ostruct"
require "i18n"

Dir[File.dirname(__FILE__) + "/**/*.rb"].each { |f| require f }
I18n.load_path += Dir[File.dirname(__FILE__) + "/config/**/*.yml"]
