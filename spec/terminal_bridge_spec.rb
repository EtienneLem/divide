require 'spec_helper'

describe Divide::TerminalBridge do
  before do
    @bridge = Divide::TerminalBridge
    @bridge.stub(:execute) { |command| "#{command}" }
  end

  describe 'class' do
    it 'executes osascript' do
      @bridge.apple_script('foozle').should == "osascript -e 'foozle'"
    end
  end

  describe 'instances' do
    before do
      @bridge.stub(:current_app_name) { 'FakeApp' }
      @terminal = Divide::TerminalBridge::Terminal.new
      @terminal.stub(:go_to_current_directory) { @terminal.do_script('cd ./fake/path') }
    end

    context 'keystrokes' do
      it 'executes keystrokes' do
        @terminal.keystroke('t').should == 'tell app "System Events" to tell process "FakeApp" to keystroke "t"'
      end

      it 'executes keystrokes with a modifier key' do
        @terminal.keystroke('command+t').should == 'tell app "System Events" to tell process "FakeApp" to keystroke "t" using command down'
      end
    end

    context 'single command' do
      it 'executes in current tab' do
        @bridge.should_receive(:apple_script).with ['tell app "FakeApp" to do script "foozle" in front window']
        @terminal.exec('foozle')
      end
    end

    context 'multiple commands' do
      it 'executes each process in a new tab' do
        @bridge.should_receive(:apple_script).with [
          'tell app "FakeApp" to do script "foozle" in front window',
          'tell app "System Events" to tell process "FakeApp" to keystroke "t" using command down',
          'tell app "FakeApp" to do script "cd ./fake/path" in front window',
          'tell app "FakeApp" to do script "barzle" in front window'
        ]
        @terminal.exec ['foozle', 'barzle']
      end
    end
  end

  describe 'bridges' do
    context Divide::TerminalBridge::Terminal do
      before do
        @bridge.stub(:current_app_name) { 'Terminal' }
        @terminal = Divide::TerminalBridge::Terminal.new
      end

      it 'executes shell script' do
        @terminal.do_script('foozle').should == 'tell app "Terminal" to do script "foozle" in front window'
      end

      it 'opens new tabs' do
        @terminal.open_new_tab.should == 'tell app "System Events" to tell process "Terminal" to keystroke "t" using command down'
      end
    end

    context Divide::TerminalBridge::ITerm do
      before do
        @bridge.stub(:current_app_name) { 'iTerm' }
        @terminal = Divide::TerminalBridge::ITerm.new
      end

      it 'executes shell script' do
        @terminal.do_script('foozle').should == 'tell app "iTerm" to tell the first terminal to tell the last session to write text "foozle"'
      end

      it 'opens new tabs' do
        @terminal.open_new_tab.should == 'tell app "iTerm" to tell the first terminal to launch session "Default Session"'
      end
    end
  end
end
