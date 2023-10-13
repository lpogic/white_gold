require_relative 'widget'
require_relative '../convention/widget_like'

class Tgui
  class MenuBar < Widget

    class ItemPressSignal
      def initialize menu_bar, item_path
        @menu_bar = menu_bar
        @item_path = item_path
      end

      def connect &on_press
        on_press = Fiddle::Closure::BlockCaller.new(0, [0], &on_press)
        it = @item_path.each
        block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
          it.next
        end
        id = MenuBar::Private.connect_menu_item @menu_bar.pointer, @item_path.size, block_caller, on_press
        MenuBar.callback_storage[id] = block_caller
        return id
      end
  
      def disconnect id
        @menu_bar.on_menu_item_click.disconnect id
      end
    end

    class MenuItem < WidgetLike
      def item text:, **na, &b
        item_path = [*path, text]
        it = item_path.each
        block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
          it.next
        end
        Private.add_menu_item @menu_bar, item_path.size, block_caller
        item = Item.new @menu_bar, item_path
        bang_nest item, **na, &b
      end

      def on_press(&b)
        signal = ItemPressSignal.new @menu_bar, path
        block_given? ? signal.connect(&b) : signal
      end

      def on_press=(a)
        on_press &a
      end

      def remove
        path_block do
          Private.remove_menu_item @menu_bar, _1, _2
        end
      end

      def remove_subitems
        path_block do
          Private.remove_sub_menu_items @menu_bar, _1, _2
        end
      end
    end

    class Menu < MenuItem
      def initialize menu_bar, text
        @menu_bar = menu_bar
        @text = text
      end

      def path_block &b
        block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
          @text
        end
        b.(1, block_caller)
      end

      def enabled=(enabled)
        @menu_bar.menu_enabled! @text, enabled
      end

      def enabled?
        @menu_bar.menu_enabled? @text
      end

      def text=(text)
        path_block do
          Private.change_menu_item @menu_bar, _1, _2, text
          @text = text
        end
      end

      def text
        @text
      end

      def path
        [@text]
      end
    end

    class Item < MenuItem
      def initialize menu_bar, path
        @menu_bar = menu_bar
        @path = path.freeze
      end

      def path_block &b
        it = @path.each
        block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_CONST_STRING, [0]) do
          it.next
        end
        b.(@path.size, block_caller)
      end

      def enabled=(enabled)
        path_block do
          Private.set_menu_item_enabled @menu_bar.pointer, _1, _2, enabled
        end        
      end

      def enabled?
        result = nil
        path_block do
          result = Private.get_menu_item_enabled @menu_bar.pointer, _1, _2
        end        
        result
      end

      def text=(text)
        path_block do
          Private.change_menu_item @menu_bar, _1, _2, text
          @path = [*@path[...-1], text]
        end
      end

      def text
        @path.last
      end

      def path
        @path
      end
    end

    def item text:, **na, &b
      add_menu text
      item = Menu.new self, text
      bang_nest item, **na, &b
    end

    def [](*path)
      path.size > 1 ? Item.new(self, path) : Menu.new(self, path[0])
    end
  end
end