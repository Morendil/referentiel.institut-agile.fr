# Test of the Agile Skills and Practices Roadmap's indexing code
require "test/unit"
require "fileutils"
require "lib/roadmap"

class TestRoadmap < Test::Unit::TestCase
 
  def setup
    @velo = {:id => :velocity, "title" => "Velo"}
    @tdd = {:id => :tdd, "title" => "Test"}
    @ci = {:id => :ci, "title" => "Cont"}
    @task = {:id => :task, "title" => "Tabl"}
  end

  def with_test_files
    FileUtils.mkdir("tmp")
    File.open("tmp/one.yml","w") {|f| f.puts("---")}
    File.open("tmp/two.yml","w") {|f| f.puts("---")}
    begin
      yield
    ensure
      FileUtils.rm_rf("tmp")
    end
  end
  
  def mock_roadmap
    list = [@velo,@tdd,@ci,@task]
    r = Roadmap.new(nil)
    r.instance_eval do
      @list = list
      def self.all
        return @list
      end
    end
    return r
  end

  def test_pick_up_yml_files_to_array
    with_test_files do
      yaml_files = Roadmap.new("tmp").list_files
      assert_equal ["tmp/one.yml","tmp/two.yml"], yaml_files
    end
  end
  
  def test_read_yaml
    with_test_files do
      empty = {}
      assert_equal empty, Roadmap.new("tmp").parse("tmp/one.yml")
    end
  end

  def test_interpret_yaml
    with_test_files do
      all = [{:id=>:one},{:id=>:two}]
      assert_equal all, Roadmap.new("tmp").all
    end
  end
  
  def test_alphabetical_order
    by_alpha = [{:letter=>"C",:values=>[@ci]},{:letter=>"T",:values=>[@task,@tdd]},{:letter=>"V",:values=>[@velo]}]
    assert_equal by_alpha, mock_roadmap.all_by_alpha
  end

end