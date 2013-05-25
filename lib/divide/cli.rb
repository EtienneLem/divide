module Divide
  class CLI
    def initialize(argv)
      @options = argv.each_slice(2).to_a

      show_version if argv.grep(/^-v|--version$/).any?
      error(:app_not_supported) unless terminal

      terminal.exec(processes)
    end

    def processes
      error(:no_profile) unless extracted_processes = extractor.extract_processes!
      extracted_processes.to_a.map { |a| a[1] }
    end

    def error(type)
      errors = {
        no_profile: "#{Dir.pwd}: There is no Procfile in this directory",
        app_not_supported: "#{current_app_name} is not yet supported, please fill in a request https://github.com/EtienneLem/divide/issues",
      }

      exit_with_message(errors[type])
    end

    def show_version
      exit_with_message("Divide #{VERSION}")
    end

    def exit_with_message(message)
      STDOUT.puts(message)
      exit 0
    end

    def current_app_name
      @current_app_name ||= TerminalBridge.current_app_name
    end

    def terminal
      @terminal ||= case current_app_name.downcase
                    when 'terminal' then TerminalBridge::Terminal.new
                    when 'iterm' then TerminalBridge::ITerm.new
                    else nil
                    end
    end

    def extractor
      @extractor ||= Extractor.new(@options)
    end
  end
end
