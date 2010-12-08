require "rubygems"
require "mustache"
require "lib/roadmap"

r = Roadmap.new("src")
Mustache.template_file = "src/alpha.tmpl"
m = Mustache.new
m[:parts] = r.all_by_alpha

puts m.render
