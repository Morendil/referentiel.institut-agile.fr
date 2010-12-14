require "rubygems"
require "mustache"
require "lib/roadmap"

r = Roadmap.new("src")
Mustache.template_file = "src/index.tmpl"

m = Mustache.new
m[:parts] = r.all_by_alpha
m[:order] = "ordre alphabétique"
File.open("src/index.ham","w") {|f| f.write m.render}
File.open("src/index_alpha.ham","w") {|f| f.write m.render}

m = Mustache.new
m[:parts] = r.all_by_type
m[:order] = "type"
File.open("src/index_type.ham","w") {|f| f.write m.render}
