module Divide
  class CLI
    attr_reader :options

    def initialize(argv=[])
      @options = argv.each_slice(2).to_a

      show_version if argv.grep(/^-v|--version$/).any?
      show_help if argv.grep(/^-h|--help$/).any?

      error(:app_not_supported) unless terminal

      processes = extract_processes
      start_processes(processes)
    end

    def start_processes(processes)
      terminal.exec(processes)
    end

    def extract_processes
      error(:no_procfile) unless extracted_processes
      extracted_processes.to_a.map { |a| a[1] }
    end

    def error(type)
      errors = {
        no_procfile: "#{current_directory}: There is no Procfile in this directory",
        app_not_supported: "#{current_app_name} is not yet supported, please fill in a request https://github.com/EtienneLem/divide/issues",
      }

      exit_with_message(errors[type], 1)
    end

    def show_version
      exit_with_message("Divide #{VERSION}")
    end

    def show_help
      exit_with_message("Usage: divide [options]")
    end

    def exit_with_message(message, code=0)
      STDOUT.puts(message)
      exit code
    end

    def current_app_name
      @current_app_name ||= TerminalBridge.current_app_name
    end

    def extracted_processes
      @extracted_processes ||= extractor.extract_processes!
    end

    def current_directory
      @current_directory ||= Dir.pwd
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
