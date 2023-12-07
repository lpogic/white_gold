module BangNestedCaller
  def bang_respond_to? name
    name.end_with?("!") && (respond_to?("#{name[...-1]}=") || respond_to?("api_#{name[...-1]}") || (@bang_target && @bang_target.respond_to?(name)))
  end

  def bang_method_missing name, *a, **na, &b
    return @bang_target.send(name, *a, **na, &b) if @bang_target && @bang_target.respond_to?(name)

    api_name = "api_#{name[...-1]}".to_sym
    return send(api_name, *a, **na, &b) if respond_to? api_name

    setter = "#{name[...-1]}=".to_sym
    if respond_to? setter
      return send(setter, a) if !a.empty?
      return send(setter, na) if !na.empty?
      return send(setter, b) if block_given?
      return send(setter)
    end

    no_method_error = NoMethodError.new("undefined bang nested method `#{name}` for #{bang_object_stack.map(&:class).join("/")}")
    raise no_method_error
  end

  def self!
    @bang_target&.respond_to?(:self!) ? @bang_target.self! : self
  end

  def bang_object_stack root = true
    stack = []
    stack << self if root
    stack << @bang_target if @bang_target
    stack += @bang_target.bang_object_stack(false) if @bang_target&.respond_to? :bang_object_stack
    return stack
  end


  def upon! item, **na, &b
    na.each do |k, v|
      item.send("#{k}=", v)
    end
    if b
      @bang_target, original_bang_target = item, @bang_target
      b.call item
      @bang_target = original_bang_target
    end
    item
  end
end
