class Divide::TerminalBridge
  def apple_script(cmd)
    cmd = cmd.join("' -e '") if cmd.is_a?(Array)
    `osascript -e '#{cmd}'`
  end

  def tell_terminal(cmd)
    %(tell app "Terminal" to #{cmd})
  end

  def do_script(script)
    tell_terminal %(do script "#{script}" in front window)
  end

  def keystroke(app, key)
    splits = key.split('+')

    if splits.length > 1
      modifier_key = splits[0]
      key = splits[1]
    else
      modifier_key = nil
      key = splits[0]
    end

    modifier = modifier_key ? " using #{modifier_key} down" : ''
    %(tell app "System Events" to tell process "#{app}" to keystroke "#{key}"#{modifier})
  end

  def exec(commands)
    scripts = commands.map { |c| do_script(c) }
    scripts_with_new_tabs = insert_between(scripts, keystroke('Terminal', 'command+t'))

    apple_script(scripts_with_new_tabs)
  end

  def insert_between(scripts, insert_between)
    scripts.flat_map { |s| [s, insert_between] }[0...-1]
  end
end
