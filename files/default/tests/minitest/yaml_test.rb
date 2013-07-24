describe_recipe "apps-couchbase::yaml" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "/srv/pillowfight/shared/config/couchbase.yml" do
    let(:app_user) { user "pillowfight" }
    let(:app_group) { group "pillowfight" }
    let(:yml) { file "/srv/pillowfight/shared/config/couchbase.yml" }
    let(:stat) { File.stat(yml.path) }

    let :node_list do
      nodes = Chef::Search::Query.new.search(:node, "role:server OR role:client").first + [node]
      nodes.sort_by(&:name).reverse.map { |node| node['cloud']['local_ipv4'] }.uniq
    end

    it "exists" do
      yml.must_exist
    end

    it "is owned by the app user" do
      assert_equal app_user.uid, stat.uid
      assert_equal app_group.gid, stat.gid
    end

    it "is mode 660" do
      assert_equal "660".oct, (stat.mode & 007777)
    end

    it "does not serialize any special types" do
      yml.wont_include "!"
    end

    it "contains information about the production buckets" do
      expected_yaml = {
        "production" => {
          "bucket" => "production_default",
          "node_list" => node_list,
          "default_ttl" => 3600,
          "key_prefix" => "pillowfight/",
          "quiet" => true,
        },
        "production_not_replicated" => {
          "bucket" => "production_not_replicated",
          "node_list" => node_list,
        },
        "production_replicated" => {
          "bucket" => "production_replicated",
          "node_list" => node_list,
        },
        "production_percent" => {
          "bucket" => "production_percent",
          "node_list" => node_list,
        },
        "production_memcached" => {
          "bucket" => "production_memcached",
          "node_list" => node_list,
        },
      }

      actual_yaml = YAML.load_file(yml.path)
      assert_equal expected_yaml, actual_yaml
    end
  end

  describe "an application not hosted on this server" do
    it "does not create a couchbase.yml file" do
      file("/srv/princess/shared/config/couchbase.yml").wont_exist
    end
  end

  describe "an application hosted on this server but not using couchbase" do
    it "does not create a couchbase.yml file" do
      file("/srv/toad/shared/config/couchbase.yml").wont_exist
    end
  end
end
