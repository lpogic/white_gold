module BangNestedCaller

  @@bang_stack = []
  @@bang_roots = []

  class << self
    def stack
      @@bang_stack
    end

    def roots
      @@bang_roots
    end

    def current root
      @@bang_roots.include?(root) ? @@bang_stack.last : root
    end

    def push object
      @@bang_stack.push object
    end
  
    def pop
      @@bang_stack.pop
    end

    def open_scope object
      @@bang_roots << object
    end

    def close_scope object
      @@bang_roots.delete_at @@bang_roots.index(object)
    end
  end

  def self!
    BangNestedCaller.current self
  end

  def bang_respond_to? name
    top = BangNestedCaller.current self
    top.respond_to?("#{name}=") || top.respond_to?("api_bang_#{name}")
  end

  def bang_method_missing name, *a, **na, &b
    top = BangNestedCaller.current self
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

  def send! &b
    if b
      BangNestedCaller.push self
      b.call self
      BangNestedCaller.pop
    end
    self
  end

  def scope! scoped = nil, *a, **na, &b
    scoped ||= self
    BangNestedCaller.open_scope self
    scoped.send! *a, **na, &b
    BangNestedCaller.close_scope self
    scoped
  end
  
end
