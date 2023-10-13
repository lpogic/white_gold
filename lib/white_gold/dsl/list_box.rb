require_relative 'widget'

class Tgui
  class ListBox < Widget
    TextAlignment = enum :left, :center, :right

    class Item
      def initialize list_box, id
        @list_box = list_box
        @id = id
      end

      def text=(text)
        @list_box.change_item_by_id @id, text
      end

      def remove
        @list_box.remove_item_by_id @id
      end

      def selected=(selected)
      end
    end

    class Items
      def initialize list_box
        @list_box = list_box
      end

      def [](unique)
        case unique
        when :selected
          id = @list_box.get_selected_item_id
          return id != "" ?  Item.new(@list_box, id) : nil
        when Integer
          id = @list_box.id_by_index unique
          return id != "" ?  Item.new(@list_box, id) : nil
        else
          id = unique.to_s
          return @list_box.contains_id? ? Item.new(@list_box, id) : nil
        end
      end

      def remove_all
        @list_box.remove_all_items
      end
    end

    @@auto_id = "@/"

    def text_alignment=(alignment)
      Private.set_text_alignment(@pointer, TextAlignment[alignment])
    end

    alias_method :text_alignment!, :text_alignment=

    def text_alignment
      TextAlignment[Private.get_text_alignment @pointer]
    end

    def item text:, id: nil
      id ||= begin
        @@auto_id.next!
      end
      add_item text, id
      Item.new self, id
    end

    def selected_item=(item)
      case item
      when nil, false then deselect_item
      when Integer then Private.set_selected_item_by_index @pointer, item
      else Private.set_selected_item_by_id @pointer, item.to_s
      end
    end

    alias_method :selected_item!, :selected_item=

    def selected_item
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
      when :selected
        Private.get_selected_item_id @pointer
      when Integer
        Private.get_item_by_index(@pointer, item)
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