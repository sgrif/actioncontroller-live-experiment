require 'multi_stream'

class MainController < ApplicationController
  include ActionController::Live
  @amount = 0

  def index
  end

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    sse = MultiStream.add_stream "messages", response.stream

    begin
      loop do
        sse.ping
        sleep 10
      end
    rescue IOError
    ensure
      MultiStream.close_stream "messages", sse
    end
  end

  def post
    MultiStream.write "messages", {user: "Guest", timestamp: Time.now, message: params[:message]}, event: :message
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end
end
