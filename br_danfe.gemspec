# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "br_danfe/version"

Gem::Specification.new do |spec|
  spec.name          = "br_danfe"
  spec.version       = BrDanfe::VERSION
  spec.summary       = "DANFE pdf generator for Brazilian invoices."
  spec.author        = "ASSEINFO"
  spec.email         = "asseinfo@asseinfo.com.br"
  spec.homepage      = "http://github.com/asseinfo/br_danfe"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri"
  spec.add_dependency "prawn"
  spec.add_dependency "barby"
  spec.add_dependency "i18n"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter"
end
