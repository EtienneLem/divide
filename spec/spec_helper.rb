$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'divide'
require File.join(File.dirname(__FILE__), './mock/cli')

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.read File.new("#{fixture_path}/#{file}")
end
