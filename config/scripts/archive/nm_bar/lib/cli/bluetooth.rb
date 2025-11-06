require "open3"

module CLI
  class Bluetooth
    def initialize(command_name:, args:)
      @command_name  = command_name
      @args = args
    end

    def run
      execute(command)
    end

    private

    attr_reader :command_name, :args

    def command
      @command ||= commands[command_name]
    end

    def execute(command)
      stdout, stderr, status = Open3.capture3(*command[:bash])

      return abort(stderr) if status.exitstatus == 1
        

      if command[:presenter] != nil
        return command[:presenter].call(stdout, args)
      end
    end

    def commands
      {
        "connect" => {
          bash: ["bt-device", "-c", args[:mac]],
        },
        "status" => {
          bash: ["bt-device", "-i", args[:mac]],
          presenter: CLI::Presentors::BluetoothPresentor.method(:status)
        } 
      }
    end
  end
end
