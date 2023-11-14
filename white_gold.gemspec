Gem::Specification.new do |s|
  s.name        = "white_gold"
  s.version     = "0.0.1"
  s.summary     = "ruby tgui gem"
  s.description = "Tgui based compact toolbox for building pure Ruby native graphics interfaces."
  s.authors     = ["Łukasz Pomietło"]
  s.email       = "oficjalnyadreslukasza@gmail.com"
  s.files       = Dir.glob('lib/**/*') + 
    Dir.glob('ext/**/*.{dll,so}') +
    Dir.glob('res/**/*')
  s.homepage    = "https://github.com/lpogic/white_gold"
  s.license       = "Zlib"
end