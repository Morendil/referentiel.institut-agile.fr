require "rubygems"
require "mustache"
require "lib/roadmap"

r = Roadmap.new("src")
Mustache.template_file = "views/book.tmpl"

m = Mustache.new
m[:parts] = r.all_by_alpha
m[:order] = "ordre alphabétique"
File.open("tmp/book.ham","w") {|f| f.write m.render}
