require 'prawn'
require 'prawn/measurement_extensions'
require 'prawn/table'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
require 'nokogiri'
require 'yaml'
require 'ostruct'
require 'i18n'
require 'br_documents'

Dir[File.dirname(__FILE__) + '/**/*.rb'].sort.each { |f| require f }
I18n.load_path << File.expand_path('../config/locales/pt-BR.yml', __dir__)
Prawn::Font::AFM.hide_m17n_warning = true

module BrDanfe
  def self.root_path
    File.expand_path('../..',__FILE__)
  end
end
