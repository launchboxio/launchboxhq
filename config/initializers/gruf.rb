# frozen_string_literal: true

require 'gruf'
require './app/proto/app/proto/Agent_services_pb.rb'

Gruf.configure do |c|
  c.interceptors.use(::Gruf::Interceptors::Instrumentation::RequestLogging::Interceptor, formatter: :logstash)
  c.error_serializer = Gruf::Serializers::Errors::Json
  c.backtrace_on_error = !Rails.env.production?
  c.use_exception_message = !Rails.env.production?
end
