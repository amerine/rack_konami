# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack_konami/version"

Gem::Specification.new do |s|
  s.name        = "rack_konami"
  s.version     = Rack::Konami::VERSION
  s.authors     = ["Mark Turner"]
  s.email       = ["mark@amerine.net"]
  s.homepage    = ""
  s.summary     = %q{Rack middlware that embeds the Konami code in your apps}
  s.description = %q{Mixes the Konami code with JavaScript to add Konami code effects to your app. Uses jQuery when available.}

  s.rubyforge_project = "rack_konami"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "shoulda"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "rake"
  s.add_runtime_dependency "rack"
end
