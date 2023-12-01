require_relative '../reducer'

module Interface

  def self.abi_const_string_method_suffix str
    return str.gsub(/([A-Z])/, '_\1').gsub(/::/, '__').downcase
  end

  def self.parse_packer packer
    case packer
    when Proc, Reducer
      packer
    when Array
      packers = packer.map{ parse_packer _1 }
      proc do |host, *a|
        ai = a.each
        packers.map do |packer|
          case packer
          when Proc then packer.call host, *ai.next
          when nil then ai.next
          when Reducer then packer.call host, *(0..packer.reduction).map{ ai.next }
          else packer
          end
        end.flatten
      end
    when Symbol
      if packer.to_s.start_with? "_"
        parse_packer "abi_pack#{packer}".to_sym
      else
        proc do |host, *a|
          host.send packer, *a
        end
      end
    when Class, Enum
      parse_packer "abi_pack#{abi_const_string_method_suffix packer.name}".to_sym
    when String
      parse_packer "abi_pack#{abi_const_string_method_suffix packer}".to_sym
    when Range
      subpacker = parse_packer packer.min
      fiddle_type = packer_fiddle_type packer.min
      if packer.exclude_end?
        proc do |host, *a|
          it = a.each
          block_caller = Fiddle::Closure::BlockCaller.new(fiddle_type, [0]) do
            subpacker.call host, it.next
          rescue StopIteration
            subpacker.call host, nil
          end
          block_caller
        end
      else
        proc do |host, *a|
          it = a.each
          block_caller = Fiddle::Closure::BlockCaller.new(fiddle_type, [0]) do
            subpacker.call host, it.next
          end
          [a.size, block_caller]
        end
      end
    when nil
      nil
    else raise "Unknown packer type #{packer.class}"
    end
  end

  def self.packer_fiddle_type type
    if type == Integer || type == "Boolean" then Fiddle::TYPE_INT
    elsif type == Float then Fiddle::TYPE_FLOAT
    elsif type == String then Fiddle::TYPE_CONST_STRING
    else Fiddle::TYPE_VOIDP
    end
  end

  def self.parse_unpacker unpacker
    case unpacker
    when Proc
      unpacker
    when Symbol
      if unpacker.to_s.start_with? "_"
        parse_unpacker "abi_unpack#{unpacker}".to_sym
      else
        proc do |host, *a|
          host.send unpacker, *a
        end
      end
    when Class, Enum
      parse_unpacker "abi_unpack#{abi_const_string_method_suffix unpacker.name}".to_sym
    when String
      parse_unpacker "abi_unpack#{abi_const_string_method_suffix unpacker}".to_sym
    when nil
      nil
    else raise "Unknown unpacker type #{unpacker.class}"
    end
  end

  def self.fiddle_type type
    if type == Integer || type == "Boolean" then Fiddle::TYPE_INT
    elsif type == Float then Fiddle::TYPE_FLOAT
    else Fiddle::TYPE_VOIDP
    end
  end

  require_relative 'interface_collection_out'
  require_relative 'interface_composed_out'
  require_relative 'interface_single_out'

  def self.from packer, unpacker
    case unpacker
    when Array then InterfaceComposedOut
    when Range then InterfaceCollectionOut
    else InterfaceSingleOut
    end.from packer, unpacker
  end
end