class InterfaceComposedOut
  include Interface

  def self.from packer, unpacker
    self.new Interface.parse_packer(packer), unpacker.map{ Interface.parse_unpacker _1 }, unpacker.map{ Interface.fiddle_type _1 }
  end
    

  def initialize packer, unpacker, fiddle_types
    @packer = packer
    @unpacker = unpacker
    # unpacking in block caller allows abi side to free memory on return eg. for strings passed by value
    @block_caller = Fiddle::Closure::BlockCaller.new(0, fiddle_types) do |*a|
      @unpacked = @unpacker.zip(a).map{ _1.call @host, _2 }
    end
  end

  # Works propertly only for single thread (like whole TGUI btw.)
  def call host, name, *a
    a = @packer.call host, *a if @packer
    @host = host
    host.send name, *a, @block_caller
    unpacked = @unpacked
    @unpacked = nil
    @host = nil
    unpacked
  end
end