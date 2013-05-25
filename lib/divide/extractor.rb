require 'yaml'

class Divide::Extractor
  def initialize(options=[])
    @procfile_content = File.read('./Procfile') rescue ''
    @options = options

    overwrite_options
    overwrite_port
  end

  def overwrite_options
    splitted_procfile = @procfile_content.split(/\s/)

    @options.each do |option|
      next if option.length < 2

      key = option[0]
      value = option[1]

      key_index = splitted_procfile.index(key)
      value_to_overwrite = splitted_procfile[key_index + 1]

      @procfile_content.sub!(value_to_overwrite, value)
    end
  end

  def overwrite_port
    @procfile_content.sub!('$PORT', ENV['PORT'] || '5000')
  end

  def extract_processes!
    return nil if @procfile_content.empty?
    YAML.load(@procfile_content)
  end
end
