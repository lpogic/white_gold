Gem::Specification.new do |s|
  s.name        = "white_gold"
  s.version     = "0.0.2"
  s.summary     = "TGUI based Ruby gem for quick native application developing"
  s.description = <<-EOT
    Ruby gem for building pure ruby graphical user interface. 
    Uses TGUI & SFML as a backend.
  EOT
  s.authors     = ["Łukasz Pomietło"]
  s.email       = "oficjalnyadreslukasza@gmail.com"
  s.files       = Dir.glob('lib/**/*') + 
    Dir.glob('ext/**/*.{dll,so}') +
    Dir.glob('res/**/*')
  s.homepage    = "https://github.com/lpogic/white_gold"
  s.license       = "Zlib"
  s.required_ruby_version     = ">= 3.2.2"
  s.add_runtime_dependency("fiddle", "~> 1.1")
end