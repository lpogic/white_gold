module Tgui
  class Theme
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

    theme_comp :button, ButtonBase::Theme
    theme_comp :chatbox, ChatBox::Theme
    theme_comp :checkbox, RadioButton::Theme
    theme_comp :child_window, ChildWindow::Theme
    theme_comp :color_picker, ColorPicker::Theme
    theme_comp :combobox, ComboBox::Theme
    theme_comp :editbox, EditBox::Theme
    theme_comp :file_dialog, FileDialog::Theme
    theme_comp :group, Group::Theme
    theme_comp :knob, Knob::Theme
    theme_comp :label, Label::Theme
    theme_comp :listbox, ListBox::Theme
    theme_comp :listview, ListView::Theme
    theme_comp :menu, MenuBar::Theme
    theme_comp :messagebox, MessageBox::Theme
    theme_comp :panel, Panel::Theme
    theme_comp :panel_listbox, PanelListBox::Theme
    theme_comp :progressbar, ProgressBar::Theme
    theme_comp :radio_button, RadioButton::Theme
    theme_comp :range_slider, RangeSlider::Theme
    theme_comp :scrollbar, Scrollbar::Theme
    theme_comp :separator, SeparatorLine::Theme
    theme_comp :slider, Slider::Theme
    theme_comp :spin_button, SpinButton::Theme
    theme_comp :tabs, Tabs::Theme
    theme_comp :textarea, TextArea::Theme
    theme_comp :toggle_button, ToggleButton::Theme
    theme_comp :treeview, TreeView::Theme
    theme_comp :widget, Widget::Theme
  end
end