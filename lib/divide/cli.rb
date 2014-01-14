module Divide
  class CLI
    attr_reader :options, :flags
    OPTIONS = %w(--tabs? --no-new-tab? --from)

    def initialize(argv=[])
      @options = {}
      OPTIONS.each do |option|
        is_boolean = option =~ /\?$/
        option_name = option.sub('--', '')

        if is_boolean
          option.sub!(/\?$/, '')
          option_name.sub!(/\?$/, '')

          @options[option_name.to_sym] = argv.include?(option)
          argv.delete(option)
        elsif argv.include?(option)
          value_index = argv.index(option) + 1

          @options[option_name.to_sym] = argv[value_index]
          argv.delete_at(value_index)
          argv.delete(option)
        end
      end

      if from = @options[:from]
        @options[:from] = "#{Dir.pwd}/#{from}"
      else
        @options[:from] = Dir.pwd
      end

      @flags = (argv).each_slice(2).to_a

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
                    when 'terminal' then TerminalBridge::Terminal.new(@options)
                    when 'iterm' then TerminalBridge::ITerm.new(@options)
                    else nil
                    end
    end

    def extractor
      @extractor ||= Extractor.new(@flags, @options)
    end
  end
end
