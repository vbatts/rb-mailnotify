# To build the gem, from this directory run
# rake gem

require 'rake/testtask'
require 'rubygems/package_task'

task :default => :gem

spec = Gem::Specification.new do |s|
  s.name = %q{rb-mailnotify}
  s.version = "0.3"
  s.authors = ["Vincent Batts"]
  s.date = %q{2012-09-12}
  s.email = %q{vbatts@hashbangbash.com}
  s.homepage = %q{https://github.com/vbatts/rb-mailnotify/}
  s.platform = Gem::Platform::RUBY
  s.summary = %q{mail notification-ish tools}
  s.description = %q{mail notification-ish tools }
  s.files = %w{
    bin/riff
    bin/mailnotify
    lib/rb-mailnotify.rb
  }
  s.executables = %w{ riff mailnotify }
  s.require_paths = %w{ lib }
  s.has_rdoc = true
  s.extra_rdoc_files = %w{ README.rdoc }
  s.rdoc_options = ["--main=README.rdoc", "--line-numbers", "--inline-source", "--title=#{s.name} #{s.version} Documentation"]
  %w{ libnotify maildir rb-inotify }.each do |dep|
    s.add_dependency dep
  end
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

Rake::TestTask.new do |t|
	t.libs << "test"
	t.test_files = FileList['test/test*.rb']
	t.verbose = true
end

