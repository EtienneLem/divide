require 'divide/terminal_bridge'

module Divide
  class TerminalBridge::ITerm < TerminalBridge
    def do_script(script)
      tell_current_app %(tell the first terminal to tell the last session to write text "#{script}")
    end

    def open_new_tab
      tell_current_app %(tell the first terminal to launch session "Default Session")
    end
  end
end
