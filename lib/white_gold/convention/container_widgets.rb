require_relative '../convention/api_child'

module Tgui

  ORDINARY_WIDGETS = {
    bitmap_button: Tgui::BitmapButton,
    button: Tgui::Button,
    canvas: Tgui::Canvas,
    chatbox: Tgui::ChatBox,
    checkbox: Tgui::CheckBox,
    child_window: Tgui::ChildWindow,
    color_picker: Tgui::ColorPicker,
    combobox: Tgui::ComboBox,
    editbox: Tgui::EditBox,
    file_dialog: Tgui::FileDialog,
    grid: Tgui::Grid,
    group: Tgui::Group,
    hola: Tgui::HorizontalLayout,
    howr: Tgui::HorizontalWrap,
    knob: Tgui::Knob,
    label: Tgui::Label,
    listbox: Tgui::ListBox,
    listview: Tgui::ListView,
    menu: Tgui::MenuBar,
    messagebox: Tgui::MessageBox,
    panel: Tgui::Panel,
    panel_listbox: Tgui::PanelListBox,
    panel_tabs: Tgui::TabContainer,
    progressbar: Tgui::ProgressBar,
    radio_button: Tgui::RadioButton,
    radio_button_group: Tgui::RadioButtonGroup,
    range_slider: Tgui::RangeSlider,
    fancy_label: Tgui::RichTextLabel,
    scrollbar: Tgui::Scrollbar,
    separator: Tgui::SeparatorLine,
    slider: Tgui::Slider,
    spin_button: Tgui::SpinButton,
    spin_control: Tgui::SpinControl,
    tabs: Tgui::Tabs,
    textarea: Tgui::TextArea,
    toggle_button: Tgui::ToggleButton,
    treeview: Tgui::TreeView,
    vela: Tgui::VerticalLayout,
  }.freeze

  UNORDINARY_WIDGETS = {
    picture: Tgui::Picture
  }

  def self.widget_set
    {}.merge ORDINARY_WIDGETS, UNORDINARY_WIDGETS
  end

  module WidgetOwner
    extend BangDef

    def self_common_widget_nest widget, *keys, id: nil, **na, &b
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
  
      widget.send! **club_params, **na, &b
    end

    def self_child_methods
      ## TO OPTIMIZE
      methods.filter{ _1.start_with? ApiChild::API_CHILD_PREFIX }
    end

    def self_equip_child_widget widget
      widget.page = page
      parent = self
      self_child_methods.each do |method|
        widget.define_singleton_method method[ApiChild::API_CHILD_PREFIX.length..] do |*a|
          parent.send(method, self, *a)
        end
      end
      widget
    end

    ORDINARY_WIDGETS.each do |m, c|
      if c
        def! m do |*a, **na, &b|
          self_common_widget_equip self_equip_child_widget(c.new), *a, **na, &b
        end
      end
    end

    def! :picture do |*a, **na, &b|
      texture = na[:texture] || Tgui::Texture.from(
        na[:url],
        na.dig(:part_rect, 0),
        na.dig(:part_rect, 1),
        na.dig(:part_rect, 2),
        na.dig(:part_rect, 3),
        na[:smooth]
      )
      transparent = na[:transparent] || false
      pic = Tgui::Picture.new texture, transparent
      self_equip_child_widget pic
      self_common_widget_equip pic, *a, **na.except(:url, :part_rect, :smooth, :transparent), &b
    end

    def! :radio do |object, *a, **na, &b|
      radio = RadioButton.new
      self_equip_child_widget radio
      radio.object = object
      na[:text] ||= object.to_s
      self_common_widget_equip radio, *a, **na, &b
    end

    def! :msg do |text, **buttons|
      buttons["OK"] = nil if buttons.empty?
      api_bang_message_box text:, position: :center, label_alignment: :center, buttons: (buttons.map do |k, v| 
        procedure = proc do |o, b, w|
          v&.call
          w.close true
        end
        [k, procedure]
      end)
    end

    @@auto_button_name = "Button0"

    def! :btn do |text = nil, **na, &on_press|
      text = @@auto_button_name = @@auto_button_name.next if !text
      api_bang_button text:, on_press:, **na
    end
  end

  class Container
    include WidgetOwner

    @@auto_widget_id = "@/"

    def self_common_widget_equip widget, *keys, **na, &b
      @@auto_widget_id = id = @@auto_widget_id.next
      add widget, id
      self_common_widget_nest widget, *keys, id:, **na, &b
    end

  end

  class TabContainer

    def add widget, name
      raise NoMethodError.new("Widget can't be added to TabContainer directly. Add it to TabContainer panel instead.")
    end
    
  end

  class ToolTip
    include WidgetOwner

    attr :widget

    def self_common_widget_equip widget, *keys, **na, &b
      @widget = widget
      self_common_widget_nest widget, *keys, **na, &b
    end
  end

end