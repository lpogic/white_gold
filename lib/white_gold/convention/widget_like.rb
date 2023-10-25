require_relative 'bang_nested_caller'

class WidgetLike
  include BangNestedCaller

  def respond_to? name
    super || bang_respond_to?(name)
  end

  def method_missing name, *a, **na, &b
    if name.end_with? "!"
      bang_method_missing name, *a, **na, &b
    else super
    end
  end

  def flags=(flags)
    flags.each do |f|
      send("#{f}=", true)
    end
  end
end