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
          if args.empty?
            self.help
          else
            self.send(args.shift, *args)
          end
        rescue NoMethodError => e
          puts e
          self.help
        end

      end

      # print the usage string, this is a fall through method.
      def help
        puts HELP_TEXT
      end

      # Open a config file, it's created if it doesn't exist already.
      def open(*args)
        @name = args.shift
        FileUtils.mkdir_p(root_dir+"scripts")
        config_path = "#{root_dir}#{@name}.yml"
        unless File.exists?(config_path)
          template    = File.exists?(user_config) ? user_config : "#{File.dirname(__FILE__)}/assets/sample.yml"
          erb         = ERB.new(File.read(template)).result(binding)
          tmp         = File.open(config_path, 'w') {|f| f.write(erb) }
        end

        system("$EDITOR #{config_path}")
        update(@name)
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
        files = Dir["#{root_dir}#{filename}*"]

        unless files.empty?
          confirm!("Are you sure you want to delete #{filename}? (type yes or no):") do
            FileUtils.rm(files)
            puts "Deleted #{filename}"
          end
        end

        update
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

            begin; FileUtils.rm("#{path}.screen"); rescue; end

            aliases << Screeninator::ConfigWriter.new(path).write!
          rescue ArgumentError => e
            puts e
          end
        end
        Screeninator::ConfigWriter.write_aliases(aliases)
      end

      def customize(*args)
        @type = args.shift
        @action = args.shift
        if !['config','template'].include?(@type)
          puts "Usage: screeninator customize [config|template]"
          puts "config - This is the default YAML config file to use."
          puts "template - This is the default screen config template, complete with ERB"
          exit
        end

        FileUtils.mkdir_p(root_dir+"defaults")

        path = case @type
        when "config"; USER_CONFIG
        when "template"; USER_SCREEN_CONFIG
        end

        if @action.nil?
          system("$EDITOR #{path}")
        end

        if @action == "delete"
          confirm!("Are you sure you want to delete #{path}? (type yes or no):") do
            FileUtils.rm(path)
            puts "Deleted #{path}"
          end
        end
      end

      private

      def root_dir
        dir = "#{ENV["HOME"]}/.screeninator/"
      end

      def sample_config
        "#{File.dirname(__FILE__)}/assets/sample.yml"
      end

      def user_config
        @config_to_copy || USER_CONFIG
      end

      def user_screen_config
        USER_SCREEN_CONFIG
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

