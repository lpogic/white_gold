require_relative "./lib/white_gold/version"

Gem::Specification.new do |s|
  s.name        = "white_gold"
  s.version     = WhiteGold::VERSION
  s.summary     = "TGUI based Ruby gem for quick native application developing"
  s.description = <<-EOT
    Ruby gem for building pure ruby graphical user interface.
    Uses TGUI & SFML as a backend.
    Dedicated to creating simple applications and learning programming.
  EOT
  s.authors     = ["Łukasz Pomietło"]
  s.email       = "oficjalnyadreslukasza@gmail.com"
  s.files       = Dir.glob('lib/**/*') + 
    Dir.glob('ext/**/*.{dll,so}')
  s.homepage    = "https://github.com/lpogic/white_gold"
  s.license       = "Zlib"
  s.required_ruby_version     = ">= 3.2.2"
  s.add_runtime_dependency("fiddle", "~> 1.1")
  s.add_runtime_dependency("extree", "~> 0.1")
  s.add_runtime_dependency("procify", "~> 0.1")
  s.metadata = {
    "documentation_uri" => "https://github.com/lpogic/white_gold/blob/master/doc/wiki/README.md",
    "homepage_uri" => "https://github.com/lpogic/white_gold"
  }
end