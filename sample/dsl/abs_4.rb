require 'white_gold'

button! text: "Show message" do
  on_press! do # note: abstract bang stack is overwritten before callback block call, but for this example it is the same: [Page, Button]
    messagebox! text: "Hello" # Button doesn't respond to 'messagebox!' but Page does. Page receives the call.
  end
end