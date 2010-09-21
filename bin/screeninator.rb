#! /usr/bin/env ruby
$:.unshift(File.dirname(__FILE__) + '/../lib') unless $:.include?(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'screeninator'

Screeninator::Cli.start(*ARGV)
