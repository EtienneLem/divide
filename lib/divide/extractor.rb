require 'yaml'

class Divide::Extractor
  def initialize
    @procfile = File.read('./Procfile')
  end

  def extract_processes!
    YAML.load(@procfile)
  end
end
