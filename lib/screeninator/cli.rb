require 'fileutils'

## 
# Author:: Jon Druse (mailto:jon@jondruse.com)
# 
# = Description
# 
# This class is where each screeninator command is implemented.
#
# == Change History
# 09/20/10:: created Jon Druse (mailto:jon@jondruse.com)
### 
module Screeninator
  class Cli
    
    class << self
      def start(*args)

        if args.empty?
          self.usage
        else
          self.send(args.shift, *args)
        end

      end

      # print the usage string, this is a fall through method.
      def usage
        puts "Usage: screeninator ACTION [Arg]"
      end
      
      # Open a config file, it's created if it doesn't exist already.
      def open(*args)
        puts "warning: passing multiple arguments to open will be ignored" if args.size > 1
        @name = args.shift
        FileUtils.mkdir_p(root_dir+"scripts")
        config_path = "#{root_dir}#{@name}.yml"
        unless File.exists?(config_path)
          template    = File.exists?(user_config) ? user_config : "#{File.dirname(__FILE__)}/assets/sample.yml"
          erb         = ERB.new(File.read(template)).result(binding)
          tmp         = File.open(config_path, 'w') {|f| f.write(erb) }
        end
        `$EDITOR #{config_path}`
        update_scripts
      end
      
      def delete(*args)
        puts "warning: passing multiple arguments to delete will be ignored" if args.size > 1
        filename = args.shift
        file_path = "#{root_dir}#{filename}.yml"
        
        if File.exists?(file_path)
          puts "Are you sure you want to delete #{filename}? (type yes or no):"
          if %w(yes Yes YES).include?(STDIN.gets.chop)
            FileUtils.rm(file_path)
            puts "Deleted #{file_path}"
          else
            puts "Aborting."
          end
        else
          puts "That file doesn't exist."
        end
        
      end
      
      def implode(*args)
        puts "delete_all doesn't accapt any arguments!" unless args.empty?
        puts "Are you sure you want to delete all screeninator configs? (type yes or no):"
        
        if %w(yes Yes YES).include?(STDIN.gets.chop)
          FileUtils.remove_dir(root_dir)
          puts "Deleted #{root_dir}"
        else
          puts "Aborting."
        end
        
      end

      def list(*args)
        verbose = args.include?("-v")
        puts "screeninator configs:"
        Dir["#{root_dir}**"].each do |path|
          next unless verbose || File.extname(path) == ".yml"
          path = path.gsub(root_dir, '').gsub('.yml','') unless verbose
          puts "    #{path}"
        end
      end
      
      # def run(*args)
      #   filename = args.shift
      #   puts "Running: #{filename}"
      #   Screeninator::Runner.new(filename).run!
      # end
      
      def update_scripts
        aliases = []
        Dir["#{root_dir}*.yml"].each do |path| 
          path = File.basename(path, '.yml')
          aliases << Screeninator::ConfigWriter.new(path).write!
        end
        
        Screeninator::ConfigWriter.write_aliases(aliases)
      end
      
      private
            
      def root_dir
        "#{ENV["HOME"]}/.screeninator/"
      end
      
      def sample_config
        "#{File.dirname(__FILE__)}/assets/sample.yml"
      end
      
      def user_config
        "#{ENV["HOME"]}/.screeninator/custom_config.yml"
      end
      
    end
    
  end
end

