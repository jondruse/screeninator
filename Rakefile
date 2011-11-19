require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "screeninator"
    gem.summary = %Q{Create and manage complex screen sessions easily.}
    gem.description = %Q{Create and manage complex screen sessions easily.}
    gem.email = "jon@jondruse.com"
    gem.homepage = "http://github.com/jondruse/screeninator"
    gem.authors = ["Jon Druse"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.post_install_message = <<-Message

Thanks for installing Screeninator!

UPGRADE WARNING - If you have a custom default config, move it to ~/.screeninator/defaults/

Remember to add the following line to your .bashrc file

[[ -s "$HOME/.screeninator/scripts/screeninator" ]] && source "$HOME/.screeninator/scripts/screeninator"

Message

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "screeninator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
