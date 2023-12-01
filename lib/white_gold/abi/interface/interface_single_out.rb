class InterfaceSingleOut
  include Interface

  def self.from packer, unpacker
    self.new Interface.parse_packer(packer), Interface.parse_unpacker(unpacker)
  end

  def initialize packer, unpacker
    @packer = packer
    @unpacker = unpacker
  end

  def call host, name, *a
    a = @packer.call host, *a if @packer
    received = host.send name, *a
    @unpacker&.call host, received
  end

end