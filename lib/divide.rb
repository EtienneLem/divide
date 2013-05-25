require 'divide/version'
require 'divide/extractor'
require 'divide/terminal_bridge'

module Divide
  def self.run(argv)
    @options = argv.each_slice(2).to_a
    error(:app_not_supported) unless terminal.current_app_supported?

    terminal.exec(processes)
    1
  end

  def self.processes
    error(:no_profile) unless extracted_processes = extractor.extract_processes!
    extracted_processes.to_a.map { |a| a[1] }
  end

  def self.error(type)
    errors = {
      no_profile: "#{Dir.pwd}: There is no Procfile in this directory",
      app_not_supported: "#{terminal.current_app} is not yet supported, please fill in a request https://github.com/EtienneLem/divide/issues",
    }

    puts errors[type]
    exit
  end

  def self.terminal
    @terminal ||= Divide::TerminalBridge.new
  end

  def self.extractor
    @extractor ||= Divide::Extractor.new(@options)
  end
end
