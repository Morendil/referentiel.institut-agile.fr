# Test of the Agile Skills and Practices Roadmap's indexing code
require "test/unit"
require "fileutils"
require "lib/roadmap"

class TestRoadmap < Test::Unit::TestCase
 
  def setup
    @velo = {:id => :velocity, "title" => "Velo", "type" => "Pra"}
    @tdd = {:id => :tdd, "title" => "Test", "type" => "Comp"}
    @ci = {:id => :ci, "title" => "Cont", "type" => "Conc"}
    @task = {:id => :task, "title" => "Tabl", "type" => "Comp"}
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
    list = [@velo,@tdd,@task,@ci]
    r = Roadmap.new(nil)
    r.instance_eval do
      @list = list
      def self.fetch
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

  def test_default_sort
    assert_equal [@ci,@task,@tdd,@velo], mock_roadmap.all
  end
  
  def test_alphabetical_order
    by_alpha = [{:group=>"C",:values=>[@ci]},{:group=>"T",:values=>[@task,@tdd]},{:group=>"V",:values=>[@velo]}]
    assert_equal by_alpha, mock_roadmap.all_by_alpha
  end

  def test_type_order
    by_type = [{:group=>"Comp",:values=>[@task,@tdd]},{:group=>"Conc",:values=>[@ci]},{:group=>"Pra",:values=>[@velo]}]
    assert_equal by_type, mock_roadmap.all_by_type
  end

end
