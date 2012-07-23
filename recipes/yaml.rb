#
# Cookbook Name:: apps-couchbase
# Recipe:: yaml
#
# Copyright 2012, getaroom
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

search :apps do |app|
  if (app['server_roles'] & node.run_list.roles).any?
    if app.fetch("ingredients", {}).any? { |role, ingredients| node.run_list.roles.include?(role) && ingredients.include?("couchbase.yml") }
      buckets = app.fetch("couchbase_buckets", {}).select do |environment, bucket|
        environment.include? node.chef_environment
      end

      roles_clause = app['couchbase_role'].map { |role| "role:#{role}" }.join(" OR ")

      nodes = search(:node, "(#{roles_clause}) AND chef_environment:#{node.chef_environment}").map do |couchbase_node|
        couchbase_node.attribute?("cloud") ? couchbase_node['cloud']['local_ipv4'] : couchbase_node['ipaddress']
      end

      template "#{app['deploy_to']}/shared/config/couchbase.yml" do
        owner app['owner']
        group app['group']
        mode "660"
        variables({
          :buckets => buckets,
          :nodes => nodes,
        })
      end
    end
  end
end
