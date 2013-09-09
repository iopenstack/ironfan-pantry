#
# Cookbook Name::       ganglia
# Description::         
# module::              GangliaHelper
#
# Copyright 2013, Technicolor, Portico
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Ironfan::CookbookUtils
include Ironfan::Discovery

# change logic :
#  for generator: discover collectors on chef server
#  for collector: user node[announces] to get collectors.  DO NOT DISCOVER!!
#  DISCOVER only works after the NEXT chef-run

module GangliaHelper

  # true  if :ganglia:generator has been announced by this node
  def is_generator?
    r = node.run_list.include? "role[ganglia_generator]"
    r = node.run_list.include? "role[ganglia_collector]" unless r
    Chef::Log.info("Ganglia::helper::is_generator? => #{r}")
    r
  end

  def own_collectors
    r = node[:ganglia][:collectors]
    r = Hash.new if r.nil?
    Chef::Log.info("Ganglia::helper::own_collectors => #{r.inspect}")
    r
  end

  def own_collectors_data
    r = Hash.new
    own_collectors.keys.each do |k|
      ip         = node['launch_spec']['ipv4']['local']
      port       = node[:ganglia][:collectors][k][:recv_port].to_i
      cluster_id = node[:ganglia][:collectors][k][:cluster_id]
      r[cluster_id] = ip, port
    end
    Chef::Log.info("Ganglia::helper::own_collectors_data => r:#{r.inspect}")
    r
  end

    # true  if :ganglia:collector has been nannounced by this node
    def is_collector?
      r = node.run_list.include? "role[ganglia_collector]"
      Chef::Log.info("Ganglia::helper::is_collector? => #{r}")
      r
    end

    def find_all_monitorable_clusters
      cluster_list = []
      realm        = node[:ganglia][:grid] || ""
      nodes = search(:node, "(cluster_set:#{node['launch_spec']['cluster_set']} AND role:ganglia_generator) OR (cluster_set:#{node['launch_spec']['cluster_set']} AND role:ganglia_collector)")
      Chef::Log.info("Ganglia::helper::find_all_monitorable_clusters => cluster_list:#{nodes.inspect}")
      if not nodes.nil?
        nodes.each do |n|
          cluster_list << n['launch_spec']['cluster_name']
        end
      end
      Chef::Log.info("Ganglia::helper::find_all_monitorable_clusters => cluster_list:#{cluster_list.inspect}")
      cluster_list.sort.uniq
    end

    def find_all_monitorable_clusters_local
      cluster_list = []
      ::Dir.mkdir("/tmp/chef-repo") if not ::Dir.exists?("/tmp/chef-repo")
      Chef::Log.info(" :::::::::::: Ganglia::helper::find_all_monitorable_clusters_local => Checking out the Chef repo")
      output = `cd /tmp/chef-repo && git clone #{node['ganglia']['portico']['repository']} .`
      Chef::Log.info(" :::::::::::: Ganglia::helper::find_all_monitorable_clusters_local => GITHUB: #{output}")
      Chef::Log.info(" :::::::::::: Ganglia::helper::find_all_monitorable_clusters_local => Grepping for stuff")
      data = `grep -r ':send_to_udp_port' /tmp/chef-repo/clusters/#{node['launch_spec']['cluster_set']}`
      data.each_line do |line|
        Chef::Log.info(" :::::::::::: Ganglia::helper::find_all_monitorable_clusters_local => Found #{line}")
        cluster_data = line.match(/(.*)[\s|\t]{1,}:send_to_udp_port[\s|\t]{1,}=>[\s|\t]{1,}(\d{4,5}).*/).to_a
        cluster_name = "#{node['launch_spec']['cluster_set']}_#{::File.basename(cluster_data[1], ".*")}"
        cluster_list.push({ :cluster_name => cluster_name, :udp_port => cluster_data[2] })
      end
      `rm -Rf /tmp/chef-repo`
      cluster_list
    end

    def find_collector_addr_info(cluster_id)
      port      = nil
      addr      = nil
      realm     = node[:ganglia][:grid] || ""
      if is_collector?
        addr = node['launch_spec']['ipv4']['local']
        port = node[:ganglia][:send_to_udp_port]
      else
        collector = search(:node, "cluster_set:#{node['launch_spec']['cluster_set']} AND role:ganglia_collector").first rescue nil
        if not collector.nil?
          addr = collector['launch_spec']['ipv4']['local']
          port = collector[:ganglia][:collectors][cluster_id][:recv_port].to_i
        end
      end
      Chef::Log.info("Ganglia::helper::find_collector_addr_info => addr:#{addr}, port:#{port}")
      return addr, port
    end
    
end

class Chef::Recipe              ; include GangliaHelper ; end
class Chef::Resource::Directory ; include GangliaHelper ; end
class Chef::Resource::Execute   ; include GangliaHelper ; end
class Chef::Resource::Template  ; include GangliaHelper ; end

