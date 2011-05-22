require 'sinatra'
require 'mustache'
require './lib/roadmap'
require './lib/helpers'

  Tilt.register Tilt[:haml], :ham

  r = Roadmap.new("src")

  helpers do
    def before_render template, data={}
      Mustache.template_file = template
      m = Mustache.new
      yield m if block_given?
      haml m.render data
    end
  end

  get '/' do
    haml :index
  end

  get '/index_alpha.html' do
    before_render "views/index.tmpl" do |m|
      m[:parts] = r.all_by_alpha
      m[:order] = "ordre alphabétique"
    end
  end

  get '/index_type.html' do
    before_render "views/index.tmpl" do |m|
      m[:parts] = r.all_by_type
      m[:order] = "type"
    end
  end

  get '/*.html' do
    src = r.find_by_id(params[:splat].first)
    pass unless src
    before_render "views/practice.tmpl", src
  end

  get '/images/*' do |file|
    send_file File.join('site',request.path)
  end

  ['/*.js','*.css'].each do |path|
    get path do |file|
      send_file File.join('site/images',request.path)
    end
  end

  not_found do
    "<h1>Cette page n'existe pas</h1>"
  end

run Sinatra::Application
