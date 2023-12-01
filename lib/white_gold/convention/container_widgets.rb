module Tgui

  WIDGETS_COLLECTION = {
    label: Tgui::Label,
    button: Tgui::Button,
    radio: false,
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
    picture: false,
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
    panel: Tgui::Panel,
    chat_box: Tgui::ChatBox
  }.freeze

  module WidgetOwner
    CHILD_API_PREFIX = "api_child_".freeze

    def common_widget_nest widget, *keys, id: nil, **na, &b
      club_params = {}
      Enumerator.new do |e|
        cl = widget.class
        while cl != Object
          e << cl
          cl = cl.superclass
        end
        e << Object
      end.to_a.reverse!.each do |key|
        if key == widget.class
          club = page.club key
          club.join id if id
        else
          club = page.club key, create_on_missing: false
        end
        club_params.merge! club.params if club
      end
  
      keys.each do |key|
        club = page.club key
        club.join id if id
        club_params.merge! club.params
      end
  
      bang_nest widget, **club_params, **na, &b
    end

    def child_methods
      methods.filter{ _1.start_with? CHILD_API_PREFIX }
    end

    def equip_child_widget widget
      widget.page = page
      parent = self
      child_methods.each do |method|
        widget.define_singleton_method method[CHILD_API_PREFIX.length..] do |*a|
          parent.send(method, self, *a)
        end
      end
      widget
    end

    WIDGETS_COLLECTION.each do |m, c|
      if c
        define_method m do |*a, **na, &b|
          common_widget_post_initialize equip_child_widget(c.new), *a, **na, &b
        end
      end
    end

    def picture *a, **na, &b
      texture = na[:texture] || Tgui::Texture.from([
        na[:url],
        na.dig(:part_rect, 0),
        na.dig(:part_rect, 1),
        na.dig(:part_rect, 2),
        na.dig(:part_rect, 3),
        na[:smooth]
      ])
      transparent = na[:transparent] || false
      pic = Tgui::Picture.new texture, transparent
      equip_child_widget pic
      common_widget_post_initialize pic, *a, **na.except(:url, :part_rect, :smooth, :transparent), &b
    end

    def radio object, *a, **na, &b
      radio = RadioButton.new
      equip_child_widget radio
      radio.object = object
      na[:text] ||= object.to_s
      common_widget_post_initialize radio, *a, **na, &b
    end

    def msg text, **buttons
      message_box text:, position: :center, label_alignment: :center, buttons: buttons.map do |k, v| 
        procedure = proc do |w|
          v.call()
          w.close true
        end
        [k, procedure]
      end
    end

    @@auto_button_name = "Button1"

    def btn text = nil, **na, &on_press
      if !text
        text = @@auto_button_name
        @@auto_button_name = @@auto_button_name.next
      end
      button text:, on_press:, **na
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

  end

  class TabContainer
    WIDGETS_COLLECTION.each do |m, c|
      if !method_defined? m
        define_method m do |name = nil, **na, &b|
          raise NoMethodError.new("Method `#{m}` should be called on Panel from TabContainer, not TabContainer itself")
        end
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