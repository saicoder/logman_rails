
class Logman
	class Log
		attr_accessor :message
		attr_accessor :log_type

		attr_accessor :data
		attr_accessor :datetime

		attr_accessor :data_type

		attr_accessor :sources

		def initialize
			@data_type = 'rails.exception'
			@log_type = 1 #error
			@datetime = Time.now.utc

			@sources = []
			@sources << Log.get_current_source
		end


		def self.get_current_source
			sr = {:name=>Socket.gethostname}
			ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
			sr[:ip_address] = ip.ip_address if ip
			sr
		end
	end
end