require 'divide/version'
require 'divide/extractor'
require 'divide/terminal_bridge/terminal'
require 'divide/terminal_bridge/iterm'

module Divide
  def self.run(argv)
    @options = argv.each_slice(2).to_a
    error(:app_not_supported) unless terminal

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
      app_not_supported: "#{current_app_name} is not yet supported, please fill in a request https://github.com/EtienneLem/divide/issues",
    }

    puts errors[type]
    exit
  end

  def self.current_app_name
    @current_app_name ||= Divide::TerminalBridge.current_app_name
  end

  def self.terminal
    @terminal ||= case current_app_name.downcase
                  when 'terminal' then Divide::TerminalBridge::Terminal.new
                  when 'iterm' then Divide::TerminalBridge::ITerm.new
                  else nil
                  end
  end

  def self.extractor
    @extractor ||= Divide::Extractor.new(@options)
  end
end
