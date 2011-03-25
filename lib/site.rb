require "rubygems"
require "mustache"
require "lib/roadmap"
require "bibtex"
require "bibtex/parser"

r = Roadmap.new("src")
p = BibTeX::Parser.new({})
r.add_bib File.read("src/AgilePractices.bib"), p

Mustache.template_file = "views/biblio.tmpl"
m = Mustache.new
m[:parts] = r.all
File.open("tmp/biblio.ham","w") {|f| f.write m.render}

Mustache.template_file = "views/index.tmpl"

m = Mustache.new
m[:parts] = r.all_by_alpha
m[:order] = "ordre alphabétique"
File.open("tmp/index_alpha.ham","w") {|f| f.write m.render}

m = Mustache.new
m[:parts] = r.all_by_type
m[:order] = "type"
File.open("tmp/index_type.ham","w") {|f| f.write m.render}
