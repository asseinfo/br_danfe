require 'prawn'
require 'prawn/measurement_extensions'
require 'prawn/table'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
require 'nokogiri'
require 'yaml'
require 'i18n'
require 'br_documents'

Dir["#{File.dirname(__FILE__)}/**/*.rb"].each { |f| require f }

I18n.load_path << File.expand_path('../config/locales/pt-BR.yml', __dir__)
I18n.available_locales = ['pt-BR']
I18n.default_locale = 'pt-BR'
I18n.enforce_available_locales = false

Prawn::Font::AFM.hide_m17n_warning = true

module BrDanfe
  def self.root_path
    File.expand_path('..', __dir__)
  end
end
