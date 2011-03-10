require "yaml"

class Roadmap

  def initialize directory
    @base = directory
  end 

  def list_files
    Dir["#{@base}/*.yml"]
  end

  def parse(filename)
    begin
      return File.open(filename) {|f| YAML::load(f)} || {}
    rescue
      puts "YAML error in "+filename+" "+$!
    end
  end

  def interpret(filename)
    hash = parse(filename)
    hash[:id] = File.basename(filename).split(".")[0].intern
    return hash
  end

  def find_by_id id
    return all.find {|v| v[:id].to_s == id.to_s}
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

  def all_by &block
    group_by all, &block 
  end

  def group_by array, &block
    grouped = array.inject({}) do
      |h,v| k = yield(v); a=h[k] || []; h.merge({ k => a << v })
    end
    restruct = grouped.keys.map {|k| {:group=>k,:values=>grouped[k]} }
    return restruct.sort_by{|v|v[:group]}
  end

  def add_bib entry, parser
    @bibs = parser.parse(entry).data
    group_bib.each do |group|
      begin
        find_by_id(group[:group])[:bibs] = group[:values]
      rescue
        puts "Oops:"+group[:group]+" has no corresponding practice in roadmap"
      end
    end
  end

  def all_bib
   @bibs
  end
 
  def group_bib
    by_keyword = lambda {|bib| bib[:keywords][0]}
    group_by @bibs, &by_keyword 
  end

end
