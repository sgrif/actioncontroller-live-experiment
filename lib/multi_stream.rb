require 'json'

module MultiStream
  SSES = Hash.new

  def self.add_stream(key, stream)
    SSES[key] ||= Array.new
    sse = SSE.new(stream)
    SSES[key] << sse
    sse
  end

  def self.close_stream(key, stream)
    SSES[key].delete(stream).close
  end

  def self.write(key, data, options = {})
    SSES[key].each { |stream| stream.write(data, options) } unless SSES[key].nil?
  end

  class SSE
    def initialize(io)
      @io = io
    end

    def write(data, options = {})
      options.each { |k,v| @io.write "#{k}: #{v}\n" }
      @io.write "data: #{JSON.dump(data)}\n\n"
    end

    def close
      @io.close
    end

    def ping
      @io.write ":\n\n"
    end
  end
end
