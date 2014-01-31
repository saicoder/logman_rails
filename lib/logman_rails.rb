require 'socket'
require 'net/http'
require 'json'
require 'uri'

require "logman_rails/version"
require 'action_dispatch'
require 'logman_rails/log'


class Logman
	def self.options
		@@options
	end	

	def self.options=(val)
		@@options = val
	end

	class Rails
	  def self.default_ignore_exceptions
	    [].tap do |exceptions|
	      exceptions << ActiveRecord::RecordNotFound if defined? ActiveRecord
	      # exceptions << AbstractController::ActionNotFound if defined? AbstractController
	      exceptions << ActionController::RoutingError if defined? ActionController
	    end
	  end

	  def initialize(app, options = {})
	    @app, @options = app, options
	    @options[:ignore_exceptions] ||= self.class.default_ignore_exceptions
	    Logman.options = @options
	  end

	  def call(env)
		@app.call(env)

		rescue Exception => exception
			options = (env['exception_notifier.options'] ||= {})
			options.reverse_merge!(@options)

			raise exception if options[:endpoint].nil? || options[:token].nil?

			unless Array.wrap(options[:ignore_exceptions]).include?(exception.class)
			  # Notifier.exception_notification(env, exception).deliver
			  # env['exception_notifier.delivered'] = true
			  newlog = Log.new
			  newlog.message = exception.to_s

			  data = {}
			  data[:exception_class] = exception.class.name
			  data[:backtrace] = exception.backtrace
			  data[:params] = env["action_dispatch.request.parameters"]

			  newlog.data = data

			  Logman.send(newlog, options[:endpoint], options[:token])
			end

			raise exception
		end
	end
  	# end of rails class

	def self.send(log, endpoint, token)
		begin
			uri = URI(endpoint)
			uri.path = '/api/write'
			uri.query = "key=#{token}"

			req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
			req.body = log.to_json

			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			  http.request(req)
			end
		rescue
			puts 'Can not send message to logman endpoint'
		end
	end

	# Writes custom message to logman endpoint 
	# Logtype is symbol, avalabile symbols are:
	#  Prameters:
	#  - log_type => type of log, avalabile types are
	#    	:error :success :warn :info
	#  - message => message in string format
	#  - optional data 
	def self.log(log_type, message, data={})
		return if message.class != String || message.empty?
		
		map = {:error=>1, :success=>2, :warn=>3, :info=>4}
		ltype = map[log_type]
		ltype = 4 if ltype.nil? #info
		
		newlog = Log.new
		newlog.message = message
		newlog.log_type = ltype
		newlog.data = data
		Logman.send(newlog, Logman.options[:endpoint], Logman.options[:token])
	end

	# Sends a warn message
	def self.warn(message, data={})
		Logman.log(:warn, message ,data)
	end

	# Sends a error message
	def self.error(message, data={})
		Logman.log(:error, message ,data)
	end

	# Sends a success message
	def self.success(message, data={})
		Logman.log(:success, message ,data)
	end

	# Sends a success message
	def self.info(message, data={})
		Logman.log(:info, message ,data)
	end
end















