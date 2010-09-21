module Screeninator
  
  class Runner
    
    def initialize(filename)
      @filename  = filename
      @file_path = "#{root_dir}#{@filename}.yml"
      process_config!
    end
    
    def run!
      template    = "#{File.dirname(__FILE__)}/assets/screen_config.screen"
      erb         = ERB.new(IO.read(template)).result(binding)
      config_path = "#{root_dir}#{@filename}.screen"
      tmp         = File.open(config_path, 'w') {|f| f.write(erb) }
      
      puts "screen -c #{config_path} -S #{@project_name.gsub(" ", "_")}"
    end
    
    private
    
    def root_dir
      "#{ENV["HOME"]}/.screeninator/"
    end
    
    def process_config!
      yaml = YAML.load(File.read(@file_path))

      raise "Your configuration file should include some tabs." if yaml["tabs"].nil?
      puts "Your configuration file didn't specify a 'project_root', using ~/" if yaml["project_root"].nil?
      if yaml["project_name"].nil?
        puts "Your configuration file didn't specify a 'project_name', using 'Fluffy Bunnies'"
        yaml["project_name"] = 'Fluffy Bunnies'
      end
      
      @escape       = yaml["escape"]
      @project_name = yaml["project_name"]
      @project_root = yaml["project_root"]
      @tabs         = []
      
      yaml["tabs"].each do |tab|
        t = OpenStruct.new
        t.name = tab.keys.first
        t.stuff = tab.values.first
        @tabs << t
      end
      
    end
    
  end
  
end