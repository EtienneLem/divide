require 'divide/terminal_bridge'

module Divide
  class TerminalBridge::Terminal < TerminalBridge
    def do_script(script)
      tell_current_app %(do script "#{script}" in front window)
    end

    def open_new_tab
      keystroke 'command+t'
    end
  end
end
