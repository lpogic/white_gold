class InterfaceCollectionOut
  include Interface

  def self.from packer, unpacker
    self.new Interface.parse_packer(packer), Interface.parse_unpacker(unpacker.min), Interface.fiddle_type(unpacker.min)
  end
    

  def initialize packer, unpacker, fiddle_type
    @packer = packer
    @unpacker = unpacker
    # unpacking in block caller allows abi side to free memory on return eg. for strings passed by value
    @block_caller = Fiddle::Closure::BlockCaller.new(0, [fiddle_type]) do |a|
      @unpacked << @unpacker.call(@host, a)
    end
  end

  # Works propertly only for single thread (like whole TGUI btw.)
  def call host, name, *a
    a = @packer.call host, *a if @packer
    @host = host
    @unpacked = []
    host.send name, *a, @block_caller
    unpacked = @unpacked
    @unpacked = nil
    @host = nil
    unpacked
  end
end