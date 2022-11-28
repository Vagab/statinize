version = File.read(File.expand_path("VERSION", __dir__)).strip

Gem::Specification.new do |s|
  s.name        = "statinize"
  s.version     = version
  s.summary     = "Statinize!"
  s.description = "Statinization gem. Allows for... lots of stuff. Try it."
  s.authors     = ["Barseek"]
  s.email       = "sergey.b@hey.com"
  s.files       = Dir["lib/**/*.rb"]
  s.license     = "MIT"
  s.platform    = Gem::Platform::RUBY
end
