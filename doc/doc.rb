class Object
  def self.doc method, text
    define_singleton_method "doc_#{method}" do
      text
    end
  end
end

require_relative './path/widget'