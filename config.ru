require 'sinatra'
require 'mustache'
require './lib/roadmap'
require './lib/helpers'

  Tilt.register Tilt[:haml], :ham

  r = Roadmap.new("src")

  get '/' do
    haml :index, {:views => 'static/site'}
  end

  get '/index_alpha.html' do
    Mustache.template_file = "views/index.tmpl"
    m = Mustache.new
    m[:parts] = r.all_by_alpha
    m[:order] = "ordre alphabétique"
    ham = m.render
    Haml::Engine.new(ham).render
  end

  get '/index_type.html' do
    Mustache.template_file = "views/index.tmpl"
    m = Mustache.new
    m[:parts] = r.all_by_type
    m[:order] = "type"
    ham = m.render
    Haml::Engine.new(ham).render
  end

  get '/images/*' do |file|
    send_file File.join('site',request.path)
  end

  get '/*.html' do
    id = params[:splat].first
    src = r.find_by_id(id)
    pass unless src
    # If found
    Mustache.template_file = "views/practice.tmpl"
    m = Mustache.new 
    ham = m.render(src)
    Haml::Engine.new(ham).render
  end

  not_found do
    "<h1>Cette page n'existe pas</h1>"
  end

run Sinatra::Application
