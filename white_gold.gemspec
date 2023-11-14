Gem::Specification.new do |s|
  s.name        = "white_gold"
  s.version     = "0.0.1"
  s.summary     = "TGUI based Ruby gem for quick native application developing"
  s.description = <<-EOT
    Ruby gem for building pure ruby graphical user interface. 
    Uses [TGUI](https://tgui.eu/) & [SFML](https://www.sfml-dev.org/) as backend."
  EOT
  s.authors     = ["Łukasz Pomietło"]
  s.email       = "oficjalnyadreslukasza@gmail.com"
  s.files       = Dir.glob('lib/**/*') + 
    Dir.glob('ext/**/*.{dll,so}') +
    Dir.glob('res/**/*')
  s.homepage    = "https://github.com/lpogic/white_gold"
  s.license       = "Zlib"
end