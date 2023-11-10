require_relative '../extern_object'

module Tgui
  class Color < ExternObject

    abi_alias :red, :get_
    abi_alias :green, :get_
    abi_alias :blue, :get_
    abi_alias :fade, :apply_opacity

    def to_a
      [red, green, blue, alpha]
    end

    def inspect
      "##{to_a.map{ _1.to_s 16}.join}"
    end
  end
end