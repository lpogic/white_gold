require_relative 'group'

module Tgui
  class BoxLayout < Group

    def remove widget
      if widget.is_a? Integer
        return _abi_remove_by_index abi_pack_integer(widget)
      end
      super
    end

    def get(*keys)
      case keys
      in [Symbol]
        id = page.clubs[keys.first]&.members&.first
        id && self_cast_up(_abi_get(abi_pack_string(id)))
      in [Integer]
        self_cast_up(_abi_get_by_index abi_pack_integer(keys.first))
      else
        Enumerator.new do |e|
          Array(self_get_widget_name keys).flatten.compact.uniq.each do |id|
            w = _abi_get(abi_pack_string(id))
            e << self_cast_up(w) if w && !w.null?
          end
        end
      end      
    end

    # internal

    def self_get_widget_name a
      case a
      when Widget
        a.name
      when Integer
        w = _abi_get_by_index abi_pack_integer(a)
        return nil if w.null?
        self_cast_up(w, equip: false).name
      when Enumerable
        a.map{ self_get_widget_name _1 }.flatten
      else
        page.clubs[a]&.members
      end
    end
  end
end