require_relative 'bang_nested_caller'

class WidgetLike
  include BangNestedCaller

  def respond_to? name
    super || bang_respond_to?(name)
  end

  def method_missing name, *a, **na, &b
    bang_method_missing name, *a, **na, &b
  end
end