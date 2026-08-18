require 'simplecov'
require 'simplecov_json_formatter'

unless ENV["NO_COVERAGE"]
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::JSONFormatter,
    SimpleCov::Formatter::HTMLFormatter
  ])
  SimpleCov.start do
    # Test support code is exercised by the specs that use it, not covered
    # on its own — the coverage gate only applies to product code.
    add_filter '/spec/support/'
  end
end

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
