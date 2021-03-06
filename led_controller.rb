require './led_map_transfer_factory'

class LEDController
  def initialize(contents)
    @contents = contents
    @queue = Queue.new
    factory = LEDMapTransferFactory.new @queue
    contents.each { |c| Thread.new { factory.new_instance(c).call } }
    # for test
    # Thread.new { loop { recv_map_dummy() } }
  end

  def switch(id)
    @contents.each do |c|
      c[:selected] = (c[:id] == id)  
    end
  end

  def light_off
    d = ([0]*8192).pack('C*')
    @queue.push d
  end

  # for test
  def recv_map_dummy
    d = UDPSocket.open do |udps|
      udps.bind('0.0.0.0', 9001)
      udps.recv(8192)
    end
    puts 'received'
  end
end
