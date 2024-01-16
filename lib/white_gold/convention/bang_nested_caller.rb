module BangNestedCaller

  @@bang_stack = []

  def self!
    @@bang_stack.last
  end

  def bang_respond_to? name
    top = @@bang_stack.include?(self) ? @@bang_stack.last : self
    top.respond_to?("#{name}=") || top.respond_to?("api_bang_#{name}")
  end

  def bang_send name, *a, **na, &b
    top = @@bang_stack.last
    api_bang_name = "api_bang_#{name}".to_sym
    return top.send(api_bang_name, *a, **na, &b) if top.respond_to? api_bang_name
    setter = "#{name}=".to_sym
    if top.respond_to? setter
      return top.send(setter, a) if !a.empty?
      return top.send(setter, na) if !na.empty?
      return top.send(setter, b) if block_given?
      return top.send(setter)
    end
    no_method_error = NoMethodError.new("bang method missing `#{name}!` for #{top.class}")
    raise no_method_error
  end

  def bang_method_missing name, *a, **na, &b
    if @@bang_stack.include?(self)
      bang_send name, *a, **na, &b
    else
      @@bang_stack.push self
      result = bang_send name, *a, **na, &b
      @@bang_stack.pop
      result
    end
  end

  def send! &b
    if b
      @@bang_stack.push self
      b.call self
      @@bang_stack.pop
    end
    self
  end

  def self.push object
    @@bang_stack.push object
  end

  def self.pop
    @@bang_stack.pop
  end
end
