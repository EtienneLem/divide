require 'yaml'

module Divide
  class Extractor
    DEFAULT_ENV = { 'PORT' => '5000' }.merge(ENV)

    def initialize(options=[])
      @options = options

      overwrite_env_variables
      overwrite_options
      escape_double_quotes
    end

    def procfile_content
      @procfile_content ||= File.read('./Procfile') rescue ''
    end

    def env_content
      @env_content ||= File.read('./.env') rescue ''
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

    def escape_double_quotes
      procfile_content.gsub!('"', '\"')
    end

    def extract_processes!
      return nil if procfile_content.empty?
      YAML.load(procfile_content)
    end

    def env_variables
      @env_variables ||= begin
        env_content.split(/\n/).inject({}) do |memo, line|
          variable, value = line.split(/=/)
          memo.merge variable => value
        end
      end
    end

    def overwrite_env_variables
      DEFAULT_ENV.merge(env_variables).each do |variable, value|
        procfile_content.gsub!("$#{variable}", value)
      end
    end
  end
end
