require 'divide/version'
require 'divide/extractor'
require 'divide/terminal_bridge'

module Divide
  def self.terminal
    @terminal ||= Divide::TerminalBridge.new
  end

  def self.extractor
    @extractor ||= Divide::Extractor.new
  end

  def self.run
    terminal.exec(processes)
    1
  end

  def self.processes
    extractor.extract_processes!.to_a.map { |a| a[1] }
  end
end
