module CLI
  module Presentors
    module BluetoothPresentor
      def self.status(result, args)
        line = result.split("\n").find do |line|
          line.include?("Connected:")
        end

        return line.strip[-1] == 0
      end
    end
  end
end
