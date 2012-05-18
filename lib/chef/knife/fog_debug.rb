class SimpleInstrumentor
  class << self
    def instrument(name, params={}, &block)
      puts "#{name}"
      puts "params:"+params.inspect
      if block_given?
        response = yield
        puts " "
        puts 'excon.response'
        puts "  #{response.status}"


        response.headers.each do |k,v|
              puts "  #{k}: #{v}"
        end

        if response.body
               puts ''
               puts "  #{response.body}"
        end
        puts ""
        response
      end
    end
  end
end

require "fog"

Fog::Connection.class_eval do
  def initialize(url, persistent=false, params={})
      #@excon = Excon.new(url, params.merge(:instrumentor=>SimpleInstrumentor))
     @excon = Excon.new(url, params)
      @persistent = persistent
  end
end

