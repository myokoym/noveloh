#!/usr/bin/env ruby

require "noveloh"
require "yaml"

pages = YAML.load(File.read("scenario-ja.yaml"))

window = Noveloh::Window.new(pages)
window.show
