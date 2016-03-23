$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'expect-call'
  s.version     = '0.1.0'
  s.date        = '2016-03-23'
  s.summary     = "Partial mocking (expect a method call)"
  s.description = "Stubs a regular object's method and expects a specific call to it."
  s.authors     = ["Andrew Shubin"]
  s.email       = 'andrey.shubin@gmail.com'
  s.files       = ["lib/expect-call.rb"]
  s.homepage    =
    'https://github.com/d-ash/expect-call'
  s.license       = 'MIT'
end
