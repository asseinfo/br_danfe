require 'simplecov'
SimpleCov.start

require "bundler/setup"
require "br_danfe"

Bundler.require(:default, :development)
Dir[File.dirname(__FILE__) + "/support/*.rb"].each { |f| require f }
I18n.locale = "pt-BR";

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run_when_matching :focus

  config.order = "random"
end
