class Tgui
  class Container
    @@names = "@/"

    WIDGETS_COLLECTION = {
      button: Tgui::Button,
      radio: Tgui::RadioButton,
      checkbox: Tgui::CheckBox,
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
      list_box: Tgui::ListBox,
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
    }.freeze

    def common_widget_post_initialize widget, name, **na, &b
      add widget, (name || @@names.next!).to_s
      bang_nest widget, **na, &b
    end

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

  class TabContainer
    WIDGETS_COLLECTION.each do |m, c|
      define_method m do |name = nil, **na, &b|
        raise NoMethodError.new("Method `#{m}` should be called on Panel from TabContainer, not TabContainer itself")
      end
    end
  end
end