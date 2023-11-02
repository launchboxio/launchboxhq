module Api
  module V1
    class EventsController < ApplicationController
      include ActionController::Live

      def cluster

        @event_store = Rails.configuration.event_store

        @event_store.subscribe_to_all_events { |event| puts event.inspect }

        response.headers['Content-Type'] = 'text/event-stream'
        response.headers['Last-Modified'] = Time.now.httpdate

        sse = SSE.new(response.stream, event: params[:stream])
        sse.write({ message: 'ping'})
        begin
          puts 'subscribing to event dstore'
          @event_store.subscribe(to: [::ProjectCreated]) do |event|
            puts event
            sse.write(event)
          end

        ensure
          sse.close
        end
      end
    end
  end
end
