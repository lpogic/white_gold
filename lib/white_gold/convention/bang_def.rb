module BangDef
  def def! name, &b
    define_method "api_bang_#{name}", &b
  end
end