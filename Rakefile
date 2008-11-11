require 'pathname'
require 'rubygems'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'spec/rake/spectask'
require "spec/story"
require 'spec/story/extensions/main'

begin
require 'opc/tasks/publish_gems'
rescue LoadError
end

GEM = "warningshot-extra-resolvers"
NAME = GEM
GEM_VERSION = "0.0.1"
AUTHOR = "Nate Murray"
EMAIL = "nate@natemurray.com"
HOMEPAGE = "http://example.com"
SUMMARY = "Extra resolvers for warningshot"

ROOT = Pathname(__FILE__).dirname.expand_path
CLEAN.include ["**/.*.sw?", "pkg", "lib/*.bundle", "*.gem", "doc/","doc/", "test/output/*", "coverage", "cache"]

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  # Uncomment this to add a dependency
  # s.add_dependency "foo"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(README.rdoc Rakefile TODO) + Dir.glob("{lib,spec}/**/*")
end

task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end


Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

Dir['tasks/*.rb'].each {|r| require r}
