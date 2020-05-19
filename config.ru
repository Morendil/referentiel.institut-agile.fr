require 'sinatra'
require 'tilt'
require 'haml'
require 'mustache'
require 'sinatra/mustache'
require 'cgi'
require './lib/roadmap'
require './lib/helpers'

  Tilt.register "ham", Tilt[:haml]

  r = Roadmap.new("src")

  use Rack::Session::Pool, :expire_after => 60 * 60
  set :session_secret, ENV['session_secret']

  helpers do

    def before_render template, data={}
      Mustache.template_file = template
      m = Mustache.new
      yield m if block_given?
      haml m.render data
    end

  end

  before do
    expires 500, :public, :must_revalidate
  end

  before '/' do
    request.path_info = '/index.html'
  end

  ## Dynamic content

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
    page = before_render "views/practice.tmpl", src
  end

  get '/comments/:id' do |id|
    cache_control :no_cache
    @id = id
    mustache :disqus, :layout => false
  end

  ## Static content
  ['index','outils','ebook','inconnu'].each do |static|
    get "/#{static}.html" do
      haml static.intern
    end
  end

  ## Static assets
  before '/assets/AgileDeAaZ.pdf' do
    puts "PDF: #{@profile.first_name} #{@profile.last_name}" if @profile
  end

  get '/assets/*' do |file|
    send_file File.join('site',request.path)
  end

  ['/*.js','*.css'].each do |path|
    get path do |file|
      send_file File.join('site/assets',request.path)
    end
  end

  not_found do
    "<h1>Cette page n'existe pas</h1>"
  end

run Sinatra::Application
