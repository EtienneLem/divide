require 'yaml'

module Divide
  class Extractor
    def initialize(options=[])
      @options = options

      overwrite_options
      overwrite_port
    end

    def procfile_content
      @procfile_content ||= File.read('./Procfile') rescue ''
    end

    def overwrite_options
      splitted_content = procfile_content.split(/\s/)

      @options.each do |option|
        next if option.length < 2

        key = option[0]
        value = option[1]

        if key_index = splitted_content.index(key)
          value_to_overwrite = splitted_content[key_index + 1]
          procfile_content.sub!(value_to_overwrite, value)
        end
      end
    end

    def overwrite_port
      procfile_content.sub!('$PORT', ENV['PORT'] || '5000')
    end

    def extract_processes!
      return nil if procfile_content.empty?
      YAML.load(procfile_content)
    end
  end
end
