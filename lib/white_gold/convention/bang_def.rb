require_relative 'bang_nested_caller'

module BangDef
  def def! name, &b
    define_method "api_bang_#{name}", &b
  end

  @@redef_index = 0

  def redef! name, &b
    @@redef_index = index = @@redef_index.next
    old = "api_bang_#{index}_#{name}"
    news = "api_bang_#{name}"
    alias_method old, news
    define_method news do |*a, **na, &bl|
      b.call old, *a, **na, &bl
    end
  end
end