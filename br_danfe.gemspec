$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'br_danfe/version'

Gem::Specification.new do |spec|
  spec.name          = 'br_danfe'
  spec.version       = BrDanfe::VERSION
  spec.summary       = 'DANFE pdf generator for Brazilian invoices.'
  spec.author        = 'ASSEINFO'
  spec.email         = 'asseinfo@asseinfo.com.br'
  spec.homepage      = 'http://github.com/asseinfo/br_danfe'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- { test,spec,features }/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5.1'

  spec.add_dependency 'barby', '0.5.1'
  spec.add_dependency 'br_documents', '>= 0.1.3'
  spec.add_dependency 'i18n', '>= 0.8.6'
  spec.add_dependency 'nokogiri', '>= 1.8'
  spec.add_dependency 'prawn', '~> 2.0'
  spec.add_dependency 'prawn-table', '0.2.2'

  spec.add_development_dependency 'byebug', '3.5.1'
  spec.add_development_dependency 'rake', '13.0.1'
  spec.add_development_dependency 'rspec', '3.6.0'
  spec.add_development_dependency 'rubocop', '0.67.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.1.0'
  spec.add_development_dependency 'simplecov', '0.17.1'
  spec.add_development_dependency 'simplecov-html', '0.10.2'
end
