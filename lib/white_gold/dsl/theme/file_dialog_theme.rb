require_relative 'widget_theme'
require_relative 'button_theme'
require_relative 'label_theme'
require_relative 'list_view_theme'
require_relative 'edit_box_theme'
require_relative 'combo_box_theme'

module Tgui
  class FileDialogTheme < WidgetTheme

    theme_comp :list_view, ListViewTheme
    theme_comp :edit_box, EditBoxTheme
    theme_comp :filename_label, LabelTheme
    theme_comp :file_type_combo_box, ComboBoxTheme
    theme_comp :button, ButtonTheme
    theme_comp :back_button, ButtonTheme
    theme_comp :forward_button, ButtonTheme
    theme_comp :up_button, ButtonTheme
    theme_attr :arrow_on_navigation_buttons_visible, :boolean
  
  end
end