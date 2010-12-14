require "yaml"

class Roadmap

  def initialize directory
    @base = directory
  end 

  def list_files
    Dir["#{@base}/*.yml"]
  end

  def parse(filename)
    return File.open(filename) {|f| YAML::load(f)} || {}
  end

  def interpret(filename)
    hash = parse(filename)
    hash[:id] = File.basename(filename).split(".")[0].intern
    return hash
  end

  def all
    @all || (@all = fetch.sort_by {|v|v["title"] || ""})
  end

  def fetch
    list_files.map{|f|interpret(f)}
  end

  def alpha value
    value["title"][0..0].upcase 
  end

  def all_by_alpha
    return all_by {|v| alpha(v)}
  end
  
  def all_by_type
    return all_by {|v| v["type"]}
  end

  def all_by 
    grouped = all.inject({}) do
      |h,v| k = yield(v); a=h[k] || []; h.merge({ k => a << v })
    end
    restruct = grouped.keys.map {|k| {:group=>k,:values=>grouped[k]} }
    return restruct.sort_by{|v|v[:group]}
  end

end
