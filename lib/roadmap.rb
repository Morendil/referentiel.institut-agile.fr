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
    return list_files.map {|f|interpret(f)}
  end

  def alpha value
    value["title"][0..0].upcase || ""
  end

  def all_by_alpha
    sorted = all.sort_by{|v|v["title"]}
    grouped = sorted.inject({}) do
      |h,v| k = alpha(v); a=h[k] || []; h.merge({ k => a << v })
    end
    return grouped.keys.map {|k| {:letter=>k,:values=>grouped[k]} }
  end

end
