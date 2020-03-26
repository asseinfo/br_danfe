module BrDanfe
  module Helper
    module Logo
      class Config < OpenStruct
        DEFAULTOPTIONS = { logo: '', logo_dimensions: {} }.freeze

        def initialize(new_options = {})
          options = DEFAULTOPTIONS.merge(config_yaml_load)
          super options.merge(new_options)
        end

        private

        def file
          File.exist?('config/br_danfe.yml') ? File.open('config/br_danfe.yml').read : ''
        end

        def config_yaml_load
          @file_read = YAML.safe_load(file)
          @file_read ? (@file_read['br_danfe'] || {})['options'] : {}
        end
      end
    end
  end
end
