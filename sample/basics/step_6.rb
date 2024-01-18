require 'white_gold'

def! :hello_world do
  messagebox! text: "Hello world" do |box|
    button! "Close" do
      on_press! do
        box.close
      end
    end
  end
end

hello_world!

# If widget should be available in every Container, define it inside the Container class

Container.def! :editbox_with_confirm do |confirm_text: "Save", **na, &b|
  grid! **na do
    editbox!
    button! text: confirm_text
    b&.call
  end
end

editbox_with_confirm! position: :center

child_window! do
  editbox_with_confirm! position: :center, confirm_text: "Send"
end