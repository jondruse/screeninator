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

      def
        
      def open(*args)
        puts "warning: passing multiple arguments to open will be ignored" if args.size > 1
        
        FileUtils.mkdir_p(root_dir)
        
        file_path = "#{root_dir}/#{*args.shift}.yml"
        
        unless File.exists?(file_path)
          File.open(file_path, 'w') {|f| f.write(default_config) }
        end
        
        `$EDITOR #{file_path}`
        
      end

      def list(*args)
        unless args.empty?
          puts "list doesn't accapt any arguments!"
        end

        puts "listing"

      end
      
      private
      
      def root_dir
        "#{ENV["HOME"]}/.screeninator/"
      end
      
      def default_config
       out <<  "# COMMENT OF SCRIPT HERE"
       out <<  "# you can make as many tabs as you wish..."
       out <<  "# tab names are actually arbitrary at this point too."
       out <<  "---"
       out <<  "- tab1:"
       out <<  "  - cd ~/foo/bar"
       out <<  "  - gitx"
       out <<  "- tab2:"
       out <<  "  - mysql -u root"
       out <<  "  - use test;"
       out <<  "  - show tables;"
       out <<  "- tab3: echo \"hello world\""
       out <<  "- tab4: cd ~/baz/ && git pull"
       out <<  "- tab5:"
       out <<  "  - cd ~/foo/project"
       out <<  "  - autotest"
      end
      
    end
    
  end
end











