require 'fileutils'

# Author:: Jon Druse (mailto:jon@jondruse.com)
# 
# = Description
# 
# This class is where each screeninator command is implemented.
#
# == Change History
# * 09/20/10:: created Jon Druse (mailto:jon@jondruse.com)
# * 03/15/11:: renmaed usage to help. adding option parser
module Screeninator
  class Cli
    
    class << self
      include Screeninator::Helper
      
      def start(*args)
        
        begin
          self.send(args.shift, *args)
        rescue NoMethodError
          self.help
        end

      end

      # print the usage string, this is a fall through method.
      def help
        puts HELP_TEXT
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

        cmd = "$EDITOR #{config_path}"
        if ENV["TEST-ENV"]
          system(cmd)
          update(@name)
        end
      end
      
      def copy(*args)
        @copy = args.shift
        @name = args.shift
        @config_to_copy = "#{root_dir}#{@copy}.yml"
        
        exit!("Project #{@copy} doesn't exist!")             unless File.exists?(@config_to_copy)
        exit!("You must specify a name for the new project") unless @name
        
        file_path = "#{root_dir}#{@name}.yml"
        
        if File.exists?(file_path)
          confirm!("#{@name} already exists, would you like to overwrite it? (type yes or no):") do
            FileUtils.rm(file_path)
            puts "Overwriting #{@name}"
          end
          
        end
        open(@name)
      end
      
      def delete(*args)
        puts "warning: passing multiple arguments to delete will be ignored" if args.size > 1
        filename = args.shift
        file_path = "#{root_dir}#{filename}.yml"
        
        if File.exists?(file_path)
          confirm!("Are you sure you want to delete #{filename}? (type yes or no):") do
            FileUtils.rm(file_path)
            puts "Deleted #{filename}"
          end
        else
          exit! "That file doesn't exist."
        end
        
      end
      
      def implode(*args)
        exit!("delete_all doesn't accapt any arguments!") unless args.empty?
        confirm!("Are you sure you want to delete all screeninator configs? (type yes or no):") do
          FileUtils.remove_dir(root_dir)
          puts "Deleted #{root_dir}"
        end
      end

      def list(*args)
        puts "screeninator configs:"
        list
      end
      
      def info(*args)
        puts "screeninator configs:"
        list(true)
      end
      
      def update(*args)
        aliases = []
        Dir["#{root_dir}*.yml"].each do |path|
          begin
            path = File.basename(path, '.yml')
            config_name = path.split("/").last
            next unless args.empty? || args.include?(config_name)
          
            begin; FileUtils.rm("#{path}.screen"); rescue; end
          
            puts "updating #{config_name}"
            aliases << Screeninator::ConfigWriter.new(path).write!
          rescue ArgumentError => e
            puts e
          end
        end
        Screeninator::ConfigWriter.write_aliases(aliases)
      end
      
      private
            
      def root_dir
        dir = "#{ENV["HOME"]}/.screeninator/"
        dir << "test/" if ENV["TEST-ENV"]
        dir
      end
      
      def sample_config
        "#{File.dirname(__FILE__)}/assets/sample.yml"
      end
      
      def user_config
        @config_to_copy || "#{ENV["HOME"]}/.screeninator/default.yml"
      end
      
      def list(verbose=false)
        Dir["#{root_dir}**"].each do |path|
          next unless verbose || File.extname(path) == ".yml"
          path = path.gsub(root_dir, '').gsub('.yml','') unless verbose
          puts "    #{path}"
        end
      end
      
    end
    
  end
end

