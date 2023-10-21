require_relative 'widget'

module Tgui
  class TreeView < Widget

    def self.path_block path, &b
      it = path.each
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
        it.next
      end
      b.(path.size, block_caller)
    end

    class Item < WidgetLike
      def initialize tree_view, path
        @tree_view = tree_view
        @path = path
      end

      attr :path

      def path_block &b
        TreeView.path_block @path, &b
      end

      def expanded=(expanded)
        path_block do
          expanded ? _abi_expand(@tree_view, _1, _2) : _abi_collapse(@tree_view, _1, _2)
        end
      end

      def collapsed=(collapsed)
        self.expanded = !collapsed
      end

      def selected=(selected)
        if selected
          path_block do
            @tree_view.select_item(_1, _2)
          end
        else
          selected_item = @tree_view.selected_item
          if selected_item.path == @path
            @tree_view.deselect_item
          end
        end
      end

      def remove
        path_block do
          @tree_view.remove_item _1, _2
        end
      end

      def item text:, **na, &b
        path = @path.push(text).flatten
        TreeView.path_block path do
          _abi_add_item @tree_view, _1, _2, true
        end
        item = Item.new @tree_view, path
        bang_nest item, **na, &b
      end
    end

    def item text:, **na, &b
      text = [text] if not Array === text
      TreeView.path_block text do
        _abi_add_item @pointer, _1, _2, true
      end
      item = Item.new self, text
      bang_nest item, **na, &b
    end

    class Items
      def initialize tree_view
        @tree_view = tree_view
      end

      def [](*path)
        return Item.new @tree_view, path
      end
    end

    def items
      Items.new self
    end

    
  end
end