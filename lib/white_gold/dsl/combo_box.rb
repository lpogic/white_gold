require_relative 'widget'

class Tgui
  class ComboBox < Widget
    ExpandDirection = enum :up, :down, :auto

    @@auto_id = "@/"

    def selected=(item)
      case item
      when nil, false then deselect_item
      when Integer then Private.set_selected_item_by_index @pointer, item
      else Private.set_selected_item_by_id @pointer, item.to_s
      end
    end

    def selected
      return Private.get_selected_item_id @pointer
    end

    def remove(item)
      case item
      when Integer then Private.remove_item_by_index @pointer, item
      else Private.remove_item_by_id @pointe, item.to_s
      end
    end

    def [](item)
      case item
      when Integer
        Private.get_item_by_id(@pointer, get_item_ids[item])
      else
        Private.get_item_by_id @pointer, item.to_s
      end
    end

    def items
      ids = []
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_VOIDP]) do |id|
        ids << ids.utf32_to_s
      end
      Private.get_item_ids @pointer, block_caller
      return ids
    end

    def contains?(id)
      Private.contains_id @pointer, id.to_s
    end

    def []=(item, value)
      case item
      when Integer
        if item < item_count
          Private.change_item_by_index @pointer, item, value
        else
          add_item value, @@auto_id.next!
        end
      else
        id = item.to_s
        if Private.contains_id @pointer, id
          Private.change_item_by_id @pointer, id, value
        else
          add_item value, id
        end
      end
    end

    def items=(items)
      remove_all_items
      items = items.map{ [_1, _1] }.to_h if Array === items
      items.each do |id, value|
        self[id] = value
      end
    end
    
  end
end