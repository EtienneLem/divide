require 'spec_helper'

describe Divide::CLI do
  let(:current_app_name) { 'FakeApp' }
  let(:current_directory) { './fake/path' }

  before do
    Divide::CLI.any_instance.stub(:current_app_name).and_return(current_app_name)
    Divide::CLI.any_instance.stub(:current_directory).and_return(current_directory)
    Divide::CLI.messages = []
  end

  context 'unsupported app' do
    it 'raises an error' do
      expect { @cli = Divide::CLI.new }.to raise_error SystemExit
      Divide::CLI.messages.should include('FakeApp is not yet supported, please fill in a request https://github.com/EtienneLem/divide/issues')
    end
  end

  context 'supported app' do
    let(:current_app_name) { 'Terminal' }
    let(:extracted_processes) { {'web' => 'bundle exec'} }

    before do
      Divide::CLI.any_instance.stub(:extracted_processes).and_return(extracted_processes)
      Divide::CLI.any_instance.stub(:start_processes).and_return('')
    end

    it 'extracts and validate options' do
      Divide::CLI::OPTIONS.should == %w(--tabs)

      @cli1 = Divide::CLI.new
      @cli1.options.should == { :tabs => false }

      @cli2 = Divide::CLI.new(%w(--tabs))
      @cli2.options.should == { :tabs => true }
    end

    it 'groups argv in pair' do
      @cli = Divide::CLI.new(%w(-p 1337 -c ./path/to/config))
      @cli.flags.should == [%w(-p 1337), %w(-c ./path/to/config)]
    end

    context 'without Procfile' do
      let(:extracted_processes) { nil }

      it 'raises an error' do
        expect { @cli = Divide::CLI.new }.to raise_error SystemExit
        Divide::CLI.messages.should include('./fake/path: There is no Procfile in this directory')
      end
    end

    context 'bridges' do
      describe 'Terminal' do
        let(:current_app_name) { 'Terminal' }

        it 'is supported' do
          @cli = Divide::CLI.new
          @cli.terminal.class.should == Divide::TerminalBridge::Terminal
        end
      end

      describe 'iTerm' do
        let(:current_app_name) { 'iTerm' }

        it 'is supported' do
          @cli = Divide::CLI.new
          @cli.terminal.class.should == Divide::TerminalBridge::ITerm
        end
      end
    end
  end
end
