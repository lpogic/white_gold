require_relative '../convention/api_child'

module Tgui

  ORDINARY_WIDGETS = {
    bitmap_button: Tgui::BitmapButton,
    button: Tgui::Button,
    canvas: Tgui::Canvas,
    chatbox: Tgui::Chatbox,
    checkbox: Tgui::Checkbox,
    child_window: Tgui::ChildWindow,
    color_picker: Tgui::ColorPicker,
    combobox: Tgui::Combobox,
    editbox: Tgui::Editbox,
    file_dialog: Tgui::FileDialog,
    grid: Tgui::Grid,
    group: Tgui::Group,
    hlayout: Tgui::Hlayout,
    hwrap: Tgui::Hwrap,
    knob: Tgui::Knob,
    label: Tgui::Label,
    listbox: Tgui::Listbox,
    listview: Tgui::Listview,
    menu: Tgui::Menu,
    panel: Tgui::Panel,
    panel_listbox: Tgui::PanelListbox,
    panel_tabs: Tgui::PanelTabs,
    progressbar: Tgui::Progressbar,
    radio: Tgui::RadioButton,
    radio_group: Tgui::RadioGroup,
    range_slider: Tgui::RangeSlider,
    fancy_label: Tgui::FancyLabel,
    scrollbar: Tgui::Scrollbar,
    separator: Tgui::Separator,
    slider: Tgui::Slider,
    spinner: Tgui::Spinner,
    spinbox: Tgui::Spinbox,
    tabs: Tgui::Tabs,
    textarea: Tgui::Textarea,
    toggle_button: Tgui::ToggleButton,
    treeview: Tgui::Treeview,
    vlayout: Tgui::Vlayout,
  }.freeze

  UNORDINARY_WIDGETS = {
    messagebox: Tgui::Messagebox,
    picture: Tgui::Picture,
    keyboard_control: Tgui::KeyboardControl
  }

  def self.widget_set
    {}.merge ORDINARY_WIDGETS, UNORDINARY_WIDGETS
  end

  module WidgetOwner
    extend BangDef

    def self_child_methods
      ## TO OPTIMIZE
      methods.filter{ _1.start_with? ApiChild::API_CHILD_PREFIX }
    end

    def self_equip_widget widget
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
      def! m do |*a, **na, &b|
        widget = c.new
        add! widget
        scope! widget, *a, **na, &b
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
      add! pic
      scope! pic, *a, **na.except(:url, :part_rect, :smooth, :transparent), &b
    end

    @@auto_btn_name = "Button0"

    def! :btn do |text = nil, **na, &on_press|
      text = @@auto_btn_name = @@auto_btn_name.next if !text
      api_bang_button text:, on_press:, **na
    end

    def! :keyboard_control do |*a, focus: true, **na, &b|
      keyboard_control = KeyboardControl.new
      add! keyboard_control
      keyboard_control.focus! if focus
      scope! keyboard_control, *a, **na, &b
    end
  end

  class Container
    include WidgetOwner

    @@auto_widget_id = "@/"

    def! :add do |widget|
      self_equip_widget widget
      @@auto_widget_id = id = @@auto_widget_id.next
      self_add widget, id
    end
  end

  class TabContainer

    def self_add widget, name
      raise NoMethodError.new("Widget can't be added to TabContainer directly. Add it to TabContainer panel instead.")
    end
    
  end

  class ToolTip
    include WidgetOwner

    attr :widget

    def! :add do |widget, *keys, **na, &b|
      @widget = widget
      scope! widget, *keys, **na, &b
    end
  end

end