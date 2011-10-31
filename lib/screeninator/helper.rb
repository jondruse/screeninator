module Screeninator
  module Helper

    help = ["Usage: screeninator ACTION [Args]\n\n"]
    help << "Available Commans:\n\n"
    help << "open CONFIG_NAME".ljust(40)                  + "Open's the config file in $EDITOR.  If it doesn't exist, it will be created."
    help << "copy CONFIG_NAME NEW_CONFIG".ljust(40)       + "Copy an existing config into a new one."
    help << "list".ljust(40)                              + "List all your current config files."
    help << "info".ljust(40)                              + "List full path of all config files, their compiled versions, and bash scripts."
    help << "customize [config|template] [delete]".ljust(40)       + "Write your own default YML config or screen template."
    help << "update [CONFIG_NAME, CONFIG_NAME]".ljust(40) + "Recompile all config files.  Helpful if you edit them without using 'screeninator open'."
    help << "implode".ljust(40)                           + "Destroy all configs, compiled configs, and bash scripts."

    HELP_TEXT = help.join("\n")

    def exit!(msg)
      puts msg
      Kernel.exit(1)
    end

    def confirm!(msg)
      puts msg
      if %w(yes Yes YES y).include?(STDIN.gets.chop)
        yield
      else
        exit! "Aborting."
      end


    end

  end
end