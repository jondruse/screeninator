module Screeninator

  class ConfigWriter

    include Screeninator::Helper

    def self.write_aliases(aliases)
      File.open("#{ENV["HOME"]}/.screeninator/scripts/screeninator", 'w') {|f| f.write(aliases.join("\n")) }
    end

    def initialize(filename)
      @filename  = filename
      @file_path = "#{root_dir}#{@filename}.yml"
      process_config!
    end

    def write!
      if File.exists?(USER_SCREEN_CONFIG)
        template    = USER_SCREEN_CONFIG
      else
        template    = "#{File.dirname(__FILE__)}/assets/screen_config.screen"
      end
      erb         = ERB.new(IO.read(template)).result(binding)
      config_path = "#{root_dir}#{@filename}.screen"
      tmp         = File.open(config_path, 'w') {|f| f.write(erb) }

      @project_name.gsub!(" ", "_")

      check = "screen -ls | grep #{@project_name}"
      attch = "screen -dr #{@project_name}"
      start = "screen -c #{config_path} -S #{@project_name}"
      %Q{alias start_#{@filename}='if [[ -n `#{check}` ]] ; then `#{attch}` ; else `#{start}`; fi'}
    end

    private

    def root_dir
      "#{ENV["HOME"]}/.screeninator/"
    end

    def process_config!
      raise ArgumentError.new("#{@file_path} is not valid YAML!")                         unless yaml = YAML.load(File.read(@file_path))
      raise ArgumentError.new("Your configuration file should include some tabs.")        if yaml["tabs"].nil?
      raise ArgumentError.new("Your configuration file didn't specify a 'project_root'")  if yaml["project_root"].nil?
      raise ArgumentError.new("Your configuration file didn't specify a 'project_name'")  if yaml["project_name"].nil?

      @escape       = yaml["escape"]
      @project_name = yaml["project_name"]
      @project_root = yaml["project_root"]
      @tabs         = []

      yaml["tabs"].each do |tab|
        t = OpenStruct.new
        t.name = tab.keys.first
        value = tab.values.first
        t.stuff = if value.is_a?(Array)
          value.join(" && ")
        else
          value
        end
        @tabs << t
      end

    end

    def write_alias(stuff)
      File.open("#{root_dir}scripts/#{@filename}", 'w') {|f| f.write(stuff) }
    end
  end

end
