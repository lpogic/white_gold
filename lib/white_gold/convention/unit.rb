class Unit
  @@default = :pc

  class << self
    attr :default

    def nominate numeric, unit = @@default
      case unit
      when :pixel, :px then numeric.px
      when :percent, :pc then numeric.pc
      else raise "Ivalid unit `#{unit}` (:px/:pixel/:pc/:percent allowed)"
      end
    end
  end
end
