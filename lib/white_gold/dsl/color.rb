require_relative '../extern_object'

module Tgui
  class Color < ExternObject
    def to_a
      [red, green, blue, alpha]
    end

    def inspect
      "##{to_a.map{ _1.to_s 16}.join}"
    end
  end
end