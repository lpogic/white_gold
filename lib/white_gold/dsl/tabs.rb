require_relative 'widget'
require_relative '../convention/widget_like'
require_relative 'signal/signal'

module Tgui
  class Tabs < Widget

    class Tab < WidgetLike

      abi_def :text=, :change_text, id: 0, String => nil
      abi_def :text, :get_, id: 0, nil => String
      abi_attr :visible?, "Boolean", :get_, id: 0
      abi_attr :enabled?, "Boolean", :get_, id: 0

    end

    api_attr :objects do
      []
    end
    api_attr :format do
      :to_s
    end

    abi_attr :auto_size?
    abi_def :deselect
    abi_def :tab_height=, :set_, Float => nil
    abi_attr :max_tab_width, Float, :maximum_tab_width
    abi_attr :min_tab_width, Float, :minimum_tab_width

    api_def :tab do |object, index: nil, **na, &b|
      text = object.then(&format)
      if !index
        index = _abi_add abi_pack_string(text), abi_pack_boolean(false)
      else
        index = abi_pack_integer(index)
        _abi_insert index, abi_pack_string(text), abi_pack_boolean(false)
      end
      objects.insert index, object
      tab = Tab.new self, index
      upon! tab, **na, &b
    end

    def remove object
      index = objects.index object
      if index && abi_unpack_bool(_abi_remove(index))
        objects.delete_at index
      end
    end

    def remove_all
      _abi_remove_all
      self.objects = []
    end

    def selected=(selected)
      index = objects.index selected
      if index
        _abi_select index
      end
    end

    def selected
      index = abi_unpack_integer _abi_get_selected_index
      index >= 0 ? objects[index] : nil
    end

    def [](object)
      index = objects.index object
      index ? Tab.new(self, index) : nil
    end

    def items
      objects
    end

    class SignalTabSelect < Signal

      def block_caller &b
        Fiddle::Closure::BlockCaller.new(0, [0]) do
          @widget.page.upon! @widget do
            b.(@widget.selected, @widget)
          end
        end
      end

    end

    abi_signal :on_tab_select, SignalTabSelect

    abi_render_attr :borders, Outline
    abi_render_attr :background_color, Color
    abi_render_attr :background_color_hover, Color
    abi_render_attr :background_color_disabled, Color
    abi_render_attr :selected_background_color, Color
    abi_render_attr :selected_background_color_hover, Color
    abi_render_attr :text_color, Color
    abi_render_attr :text_color_hover, Color
    abi_render_attr :text_color_disabled, Color
    abi_render_attr :selected_text_color, Color
    abi_render_attr :selected_text_color_hover, Color
    abi_render_attr :border_color, Color
    abi_render_attr :border_color_hover, Color
    abi_render_attr :selected_border_color, Color
    abi_render_attr :selected_border_color_hover, Color
    abi_render_attr :texture_tab, Texture
    abi_render_attr :texture_tab_hover, Texture
    abi_render_attr :texture_selected_tab, Texture
    abi_render_attr :texture_selected_tab_hover, Texture
    abi_render_attr :texture_disabled_tab, Texture
    abi_render_attr :distance_to_side, Float
    
  end
end