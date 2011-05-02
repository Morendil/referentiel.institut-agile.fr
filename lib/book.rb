require "rubygems"
require "mustache"
require "rake"
require "lib/roadmap"

r = Roadmap.new("src")
Mustache.template_file = "views/book.tmpl"

m = Mustache.new
m[:parts] = r.all_by_alpha

File.open("tmp/book.ham","w") {|f| f.write m.render}
