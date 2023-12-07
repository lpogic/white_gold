module ApiDef
  def api_def name, &b
    define_method "api_#{name}", &b
  end
end