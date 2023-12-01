require_relative 'bang_nested_caller'

module BangNest
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
end