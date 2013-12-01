require 'sinatra'
require 'tilt'
require 'json'
require 'haml'
require 'mustache'
require 'sinatra/mustache'
require 'linkedin'
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

    def profile
      return @profile = session[:profile] if session[:profile]
      retrieve_profile
    end

    def retrieve_profile
      return false unless (cookie = request.cookies["oauth"]) || (result = session.delete(:oauth))
      begin
        client=LinkedIn::Client.new(ENV['LinkedIn_Key'],ENV['LinkedIn_Secret'])
        connect_client client, cookie, result
        session[:profile] = @profile = (client.profile :public => true)
      rescue
      ensure
        @profile
      end
    end

    def connect_client client, cookie, result
      response.delete_cookie("oauth")
      client.authorize_from_access(cookie.split("&")[0],cookie.split("&")[1]) if cookie
      cookie = client.authorize_from_request(result.token, result.secret,params[:oauth_verifier]) if result
      response.set_cookie(
        "oauth",
        {:domain=>"institut-agile.fr",
         :path=>"/",
         :value=>cookie}) if cookie
    end

  end

  before do
    expires 500, :public, :must_revalidate
  end

  before '/' do
    request.path_info = '/index.html'
  end

  ## Login workflow
  get '/status' do
      cache_control :no_cache
      profile ? (haml :logged, :layout=>false) : (haml :notlogged, :layout=>false)
  end

  get '/login' do
    session.delete(:profile)
    response.delete_cookie("oauth")
    from = CGI::escape(request.referrer)
    callback = "/done?backto=#{CGI::escape(request.referrer)}"
    #
    client=LinkedIn::Client.new(ENV['LinkedIn_Key'],ENV['LinkedIn_Secret'])
    result = client.request_token :oauth_callback => to(callback)
    session[:oauth]=result
    redirect result.authorize_url
  end

  get '/done' do
    retrieve_profile
    where = params[:backto] || "/";
    puts "Logged in: #{profile.first_name} #{profile.last_name}" if @profile
    redirect to(where)
  end

  ## Dynamic content

  get '/index_json' do
    content_type 'text/json', :charset => 'utf-8'
    r.all.to_json
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
    @default_layout = nil
    page = before_render "views/practice.tmpl", src
  end

  get '/comments/:id' do |id|
    cache_control :no_cache
    @id = id
    mustache :disqus, :layout => false
  end

  ## Temporary redirect
  get '/json.phtml' do
    one = params[:id]
    two = params[:jsonp]
    three = params[:_]
    redirect "http://jsonpify.heroku.com/?resource=http://referentiel.institut-agile.fr/#{one}.html&callback=#{two}&_=#{three}"
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
