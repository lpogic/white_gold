module Delegate
  def delegate attr, *classes
    classes.each do |cl|
      cl.instance_methods(false).filter{ ![:method_missing, :respond_to?].include? _1}.each do |m|
        define_method m do |*a, **na, &b|
          instance_variable_get("@#{attr}").send(m, *a, **na, &b)
        end
      end
    end
  end
end
