require 'yaml'

module Divide
  class Extractor
    DEFAULT_ENV = { 'PORT' => '5000' }.merge(ENV)

    def initialize(flags = [], options = {})
      @flags = flags
      @options = options

      overwrite_env_variables
      overwrite_flags
      escape_double_quotes
    end

    def procfile_content
      @procfile_content ||= File.read("#{@options[:from]}/Procfile") rescue ''
    end

    def env_content
      @env_content ||= File.read("#{@options[:from]}/.env") rescue ''
    end

    def overwrite_flags
      @flags.each do |option|
        next if option.length < 2

        key = option[0]
        value = option[1]

        procfile_content.scan(/\s?#{key}\s(\S+)/).each do |value_to_overwrite|
          procfile_content.gsub!(value_to_overwrite[0], value)
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
          next {} if variable == nil || variable.chars.first == '#'
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
