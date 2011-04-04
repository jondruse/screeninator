require 'yaml'
require 'ostruct'
require 'erb'
require 'screeninator/helper'
require 'screeninator/cli'
require 'screeninator/config_writer'

module Screeninator
  USER_CONFIG        = "#{ENV["HOME"]}/.screeninator/defaults/default.yml"
  USER_SCREEN_CONFIG = "#{ENV["HOME"]}/.screeninator/defaults/screen_config.screen"  
end
