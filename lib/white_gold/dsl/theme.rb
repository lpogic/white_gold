require 'tempfile'
require_relative '../abi/extern_object'
require_relative '../convention/bang_nest'
Dir.each_child File.dirname(__FILE__) + "/theme" do |filename|
  require_relative "theme/#{filename}"
end

module Tgui
  class Theme < ExternObject
    include BangNest
    extend ThemeAttributed
    
    class << self

      def default=(theme)
        _abi_set_default Util.expand_path(theme)
      end

      def default
        self.new pointer: _abi_get_default
      end

      def finalizer pointer
        _abi_finalizer pointer
      end
      
      def loadpath seed
        case seed
        when :light then File.dirname(File.dirname(__FILE__)) + '/library/theme/light.rb'
        when String then Util.expand_path(seed)
        else raise "#{seed} not available"
        end
      end

      def api_attr name, &init
        define_method "#{name}=" do |value|
          @@data_storage[Theme.get_unshared(@pointer).to_i][name] = value
        end
  
        init ||= proc{ nil }
  
        define_method name do
          @@data_storage[Theme.get_unshared(@pointer).to_i][name] ||= init.()
        end
      end
    end

    abi_static :get_unshared

    api_attr :attributes do
      {}
    end
    api_attr :next_renderer_id do
      "_0"
    end

    attr :source
    def source=(path)
      @source = Util.expand_path(path)
    end

    def reset_attributes
      self.attributes = {}
    end

    def! :custom do |comp, seed, **na, &b|
      self.next_renderer_id = renderer_id = next_renderer_id.next
      send("#{comp}!", renderer_id, seed, **na, &b)
      self_commit
      renderer_id
    end


    theme_attr :text_color, :color
    theme_attr :text_color_hover, :color
    theme_attr :text_color_disabled, :color
    theme_attr :background_color, :color
    theme_attr :background_color_hover, :color
    theme_attr :background_color_disabled, :color
    theme_attr :selected_text_color, :color
    theme_attr :selected_text_color_hover, :color
    theme_attr :selected_background_color, :color
    theme_attr :selected_background_color_hover, :color
    theme_attr :border_color, :color
    theme_attr :borders, :outline
    theme_attr :scrollbar_width, :float
    theme_attr :arrow_background_color, :color
    theme_attr :arrow_background_color_hover, :color
    theme_attr :arrow_background_color_disabled, :color
    theme_attr :arrow_color, :color
    theme_attr :arrow_color_hover, :color
    theme_attr :arrow_color_disabled, :color

    theme_comp :button, ButtonTheme
    theme_comp :chat_box, ChatBoxTheme
    theme_comp :child_window, ChildWindowTheme
    theme_comp :color_picker, ColorPickerTheme
    theme_comp :combobox, ComboBoxTheme, "ComboBox"
    theme_comp :editbox, EditBoxTheme, "EditBox"
    theme_comp :file_dialog, FileDialogTheme
    theme_comp :group, GroupTheme
    theme_comp :knob, KnobTheme
    theme_comp :label, LabelTheme
    theme_comp :listbox, ListBoxTheme, "ListBox"
    theme_comp :list_view, ListViewTheme
    theme_comp :menu, MenuBarTheme, "MenuBar"
    theme_comp :message_box, MessageBoxTheme
    theme_comp :progress_bar, ProgressBarTheme
    theme_comp :radio_button, RadioButtonTheme
    theme_comp :scrollbar, ScrollbarTheme
    theme_comp :separator, SeparatorLineTheme
    theme_comp :slider, SliderTheme
    theme_comp :spin_button, SpinButtonTheme
    theme_comp :tabs, TabsTheme
    theme_comp :text_area, TextAreaTheme
    theme_comp :tree_view, TreeViewTheme
    theme_comp :widget, WidgetTheme
    
    def self_commit custom_rendered = nil
      if attributes.size > 0
        file = Tempfile.new
        begin
          if @source
            File.foreach @source do |line|
              file << line
            end
          end
          attributes.each do |k, v|
            file << v.to_theme << "\n"
          end
          file.close
          _abi_load file.path
        ensure
          file.close!
        end
      else
        _abi_load @source if @source
      end
      custom_rendered&.each do |widget, renderer|
        widget.self_renderer = renderer
      end
    end
  end
end