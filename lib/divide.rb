require 'divide/version'
require 'divide/extractor'
require 'divide/terminal_bridge'

module Divide
  def self.run(argv)
    @options = argv.each_slice(2).to_a
    terminal.exec(processes)
    1
  end

  def self.processes
    no_profile unless extracted_processes = extractor.extract_processes!
    extracted_processes.to_a.map { |a| a[1] }
  end

  def self.no_profile
    puts "#{Dir.pwd}: There is no Procfile in this directory"
    exit
  end

  def self.terminal
    @terminal ||= Divide::TerminalBridge.new
  end

  def self.extractor
    @extractor ||= Divide::Extractor.new(@options)
  end
end
