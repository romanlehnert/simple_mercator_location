Gem::Specification.new do |s|
  s.name        = 'simple_mercator_location'
  s.version     = '1.0.0'
  s.date        = '2013-06-29'
  s.summary     = "A tiny lib for the mercator projecton"
  s.description = "Converts WSG84 Coordinates via Mercator-projection to meters and tiles"
  s.authors     = ["Roman Lehnert"]
  s.email       = 'roman.lehnert@googlemail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/romanlehnert/simple_mercator_location'
  s.license     = "MIT"
  s.test_files  = Dir.glob("{spec,test}/**/*.rb")
end
