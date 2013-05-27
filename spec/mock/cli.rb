module Divide
  module Mock
    module CLI
      def self.included(base)
        base.class_eval do

          def self.messages
            @@messages ||= []
          end

          def self.messages=(messages)
            @@messages = messages
          end

          def exit_with_message(message, code)
            Divide::CLI.messages << message
            exit code
          end
        end
      end
    end
  end
end

Divide::CLI.send :include, Divide::Mock::CLI
