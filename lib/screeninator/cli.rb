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
      ## 
      # Author:: Jon Druse (mailto:jon@jondruse.com)
      #
      # == Parameters
      #
      # * +args+ - Array - accepts any amount of args
      # 
      # == Change History
      # 09/20/10:: added documentation Jon Druse (mailto:jon@jondruse.com)
      ### 
      def start(*args)

        if args.empty?
          self.usage
        else
          self.send(args.shift, *args)
        end

      end

      def usage
        puts "Usage: screeninator ACTION [Arg]"
      end

      def open(*args)
        puts "warning: passing multiple arguments to open will be ignored" if args.size > 1
        
        FileUtils.mkdir_p(root_dir)
        
        file_path = "#{root_dir}#{args.shift}.yml"
        
        unless File.exists?(file_path)
          FileUtils.cp(sample_config, file_path)
        end
        
        `$EDITOR #{file_path}`
        
      end
      
      def delete(*args)
        puts "warning: passing multiple arguments to delete will be ignored" if args.size > 1
        filename = args.shift
        puts "Are you sure you want to delete #{filename}? (type yes or no):"
        
        if %w(yes Yes YES).include?(STDIN.gets.chop)
          file_path = "#{root_dir}#{filename}.yml"
          FileUtils.rm(file_path)
          puts "Deleted #{file_path}"
        else
          puts "Aborting."
        end
        
      end
      
      def delete_all(*args)
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
          path = path.gsub(root_dir, '').gsub('.yml','') unless verbose
          puts "    #{path}"
        end
      end
      
      def run(*args)
        filename = args.shift
        file_path = "#{root_dir}#{filename}.yml"
        puts "Running: #{filename}"
        
        Screeninator::Runner.new(file_path).run!
      end
      
      private
      
      def root_dir
        "#{ENV["HOME"]}/.screeninator/"
      end
      
      def sample_config
        "#{File.dirname(__FILE__)}/assets/sample.yml"
      end
      
    end
    
  end
end

