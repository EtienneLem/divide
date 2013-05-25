class Divide::TerminalBridge
  attr_reader :app_name

  # Class methods
  def self.apple_script(cmd)
    cmd = cmd.join("' -e '") if cmd.is_a?(Array)
    `osascript -e '#{cmd}'`
  end

  def self.current_app_name
    @current_app_name ||= apple_script('tell app "System Events" to get name of the first process whose frontmost is true').strip
  end

  # Instance methods
  def initialize
    @app_name = bridge.current_app_name
  end

  def bridge
    @bridge ||= Divide::TerminalBridge
  end

  def tell_current_app(cmd)
    %(tell app "#{@app_name}" to #{cmd})
  end

  def open_new_tab_in_current_directory
    [open_new_tab, go_to_current_directory]
  end

  def go_to_current_directory
    do_script "cd #{Dir.pwd}"
  end

  def keystroke(key)
    splits = key.split('+')

    if splits.length > 1
      modifier_key = splits[0]
      key = splits[1]
    else
      modifier_key = nil
      key = splits[0]
    end

    modifier = modifier_key ? " using #{modifier_key} down" : ''
    %(tell app "System Events" to tell process "#{@app_name}" to keystroke "#{key}"#{modifier})
  end

  def exec(commands)
    scripts = commands.map { |c| do_script(c) }
    scripts_with_new_tabs = insert_between(scripts, open_new_tab_in_current_directory).flatten

    bridge.apple_script(scripts_with_new_tabs)
  end

  def insert_between(array, insert_between)
    array.flat_map { |a| [a, insert_between] }[0...-1]
  end
end
