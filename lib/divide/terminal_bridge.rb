class Divide::TerminalBridge
  APP_SUPPORTED = %w(terminal iterm)

  def apple_script(cmd)
    cmd = cmd.join("' -e '") if cmd.is_a?(Array)
    `osascript -e '#{cmd}'`
  end

  def tell_current_application(cmd)
    %(tell app "#{current_app}" to #{cmd})
  end

  def current_app
    @current_app_name ||= apple_script('tell app "System Events" to get name of the first process whose frontmost is true').strip
  end

  def current_app_supported?
    APP_SUPPORTED.include?(current_app.downcase)
  end

  def do_script(script)
    case current_app.downcase
    when 'terminal' then tell_current_application %(do script "#{script}" in front window)
    when 'iterm' then tell_current_application %(tell the first terminal to tell the last session to write text "#{script}")
    end
  end

  def open_new_tab
    case current_app.downcase
    when 'terminal' then keystroke 'command+t'
    when 'iterm' then tell_current_application %(tell the first terminal to launch session "Default Session")
    end
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
    %(tell app "System Events" to tell process "#{current_app}" to keystroke "#{key}"#{modifier})
  end

  def exec(commands)
    scripts = commands.map { |c| do_script(c) }
    scripts_with_new_tabs = insert_between(scripts, open_new_tab_in_current_directory).flatten

    apple_script(scripts_with_new_tabs)
  end

  def insert_between(array, insert_between)
    array.flat_map { |a| [a, insert_between] }[0...-1]
  end
end
