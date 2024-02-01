require_relative '../abi/extern_object'

module Tgui
  class Outline < ExternObject

    def self.finalizer pointer
      _abi_delete pointer
    end

    def self.from *arg
      case arg.size
      when 1
        a = arg.first
        case a
        when Outline
          return a
        when String, Numeric
          o = arg * 4
        else raise "Unsupported argument #{arg}"
        end
      when 2
        o = [arg[0], arg[0], arg[1], arg[1]]
      when 3
        o = [arg[0], arg[1], arg[2], arg[2]]
      when 4
        o = arg
      else raise "Unsupported argument #{arg}"
      end
      o = o.map do |v|
        case v
        when Numeric then Unit.nominate(v)
        when String then v
        else raise "Unsupported arguments #{arg}"
        end
      end
      Outline.new *o
    end

    abi_def :left, :get_, nil => Float
    abi_def :right, :get_, nil => Float
    abi_def :top, :get_, nil => Float
    abi_def :bottom, :get_, nil => Float

    def to_a
      [left, right, top, bottom]
    end

    def to_s
      "(#{to_a.join(", ")})"
    end

    def inspect
      to_s
    end
  end
end