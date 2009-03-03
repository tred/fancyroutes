# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fancyroutes}
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["The TRED Team"]
  s.autorequire = %q{fancyroutes}
  s.date = %q{2009-03-04}
  s.email = %q{tred3000@gmail.com}
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["LICENSE", "README.md", "Rakefile", "lib/fancyroutes.rb", "spec/fancyroutes_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tred/fancyroutes}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = nil

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
