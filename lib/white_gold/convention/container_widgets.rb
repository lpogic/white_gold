module Tgui

  WIDGETS_COLLECTION = {
    label: Tgui::Label,
    button: Tgui::Button,
    radio: Tgui::RadioButton,
    radio_button: Tgui::RadioButton,
    checkbox: Tgui::CheckBox,
    child_window: Tgui::ChildWindow,
    editbox: Tgui::EditBox,
    combobox: Tgui::ComboBox,
    color_picker: Tgui::ColorPicker,
    hola: Tgui::HorizontalLayout,
    vela: Tgui::VerticalLayout,
    howr: Tgui::HorizontalWrap,
    group: Tgui::Group,
    radio_group: Tgui::RadioButtonGroup,
    grid: Tgui::Grid,
    list_view: Tgui::ListView,
    picture: false, # dont define defult method
    bitmap_button: Tgui::BitmapButton,
    knob: Tgui::Knob,
    message_box: Tgui::MessageBox,
    file_dialog: Tgui::FileDialog,
    listbox: Tgui::ListBox,
    menu: Tgui::MenuBar,
    panel_list_box: Tgui::PanelListBox,
    progress_bar: Tgui::ProgressBar,
    range_slider: Tgui::RangeSlider,
    rich_text_label: Tgui::RichTextLabel,
    separator_line: Tgui::SeparatorLine,
    slider: Tgui::Slider,
    spin_button: Tgui::SpinButton,
    spin_control: Tgui::SpinControl,
    tabs: Tgui::Tabs,
    tab_container: Tgui::TabContainer,
    text_area: Tgui::TextArea,
    toggle_button: Tgui::ToggleButton,
    tree_view: Tgui::TreeView,
    scrollbar: Tgui::Scrollbar,
    panel: Tgui::Panel
  }.freeze

  module WidgetOwner
    WIDGETS_COLLECTION.each do |m, c|
      if c
        define_method m do |name = nil, **na, &b|
          common_widget_post_initialize c.new, name, **na, &b
        end
      end
    end

    def picture name = nil, **na, &b
      texture = na[:texture] || Tgui::Texture.produce([
        na[:url],
        na.dig(:part_rect, 0),
        na.dig(:part_rect, 1),
        na.dig(:part_rect, 2),
        na.dig(:part_rect, 3),
        na[:smooth]
      ])
      transparent = na[:transparent] || false
      pic = Tgui::Picture.new texture, transparent
      common_widget_post_initialize pic, name, **na.except(:url, :part_rect, :smooth, :transparent), &b
    end
  end

  class Container
    include WidgetOwner

    @@auto_widget_id = "@/"

    def common_widget_post_initialize widget, *keys, **na, &b
      @@auto_widget_id = id = @@auto_widget_id.next
      add widget, id
      common_widget_nest widget, *keys, id:, **na, &b
    end

    def [](*keys)
      if keys.size == 1 && keys.first.is_a?(Symbol)
        id = page.clubs[keys.first]&.members&.first
        return id && get(id)
      else
        Enumerator.new do |e|
          keys.map{ page.clubs[_1]&.members }.compact.reduce(:+).uniq.each do |id|
            if id.is_a? Widget
              a << id
            else
              widget = get id
              e << widget if widget
            end
          end
        end
      end
    end
  end

  class TabContainer
    WIDGETS_COLLECTION.each do |m, c|
      define_method m do |name = nil, **na, &b|
        raise NoMethodError.new("Method `#{m}` should be called on Panel from TabContainer, not TabContainer itself")
      end
    end
  end

  class ToolTip
    include WidgetOwner

    attr :widget

    def common_widget_post_initialize widget, *keys, **na, &b
      @widget = widget
      common_widget_nest widget, *keys, **na, &b
    end
  end

end