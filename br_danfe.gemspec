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
  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'barby', '0.6.8'
  spec.add_dependency 'br_documents', '>= 0.1.3'
  spec.add_dependency 'i18n', '>= 0.8.6'
  spec.add_dependency 'nokogiri', '>= 1.8'
  spec.add_dependency 'prawn', '~> 2.4.0'
  spec.add_dependency 'prawn-table', '0.2.2'
  spec.add_dependency 'rqrcode', '>= 2.1', '< 2.3'

  spec.add_development_dependency 'byebug', '11.1.3'
  spec.add_development_dependency 'guard', '~> 2.18.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.7.3'
  spec.add_development_dependency 'pdf-inspector', '~> 1.3.0'
  spec.add_development_dependency 'rake', '13.1.0'
  spec.add_development_dependency 'rspec', '3.13.0'
  spec.add_development_dependency 'rubocop', '~> 1.61.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.20.2'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.27.0'
  spec.add_development_dependency 'simplecov', '0.17.1'
  spec.add_development_dependency 'simplecov-html', '0.10.2'
end
