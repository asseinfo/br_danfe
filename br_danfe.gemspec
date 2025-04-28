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
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'barby', '0.6.9'
  spec.add_dependency 'br_documents', '>= 0.1.3'
  spec.add_dependency 'i18n', '>= 0.8.6'
  spec.add_dependency 'nokogiri', '>= 1.8'
  spec.add_dependency 'prawn', '~> 2.5.0'
  spec.add_dependency 'prawn-table', '0.2.2'
  spec.add_dependency 'rqrcode', '>= 2.1', '< 2.3'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
