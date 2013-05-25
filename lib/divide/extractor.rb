require 'yaml'

class Divide::Extractor
  def initialize(options=[])
    @procfile_content = File.read('./Procfile')
    splitted_procfile = @procfile_content.split(/\s/)

    options.each do |option|
      key = option[0]
      value = option[1]

      key_index = splitted_procfile.index(key)
      value_to_overwrite = splitted_procfile[key_index + 1]

      @procfile_content.sub!(value_to_overwrite, value)
    end
  end

  def extract_processes!
    YAML.load(@procfile_content)
  end
end
