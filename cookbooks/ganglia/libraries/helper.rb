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

module GangliaHelper

    def get_announced_collector_port(cluster_id)
        realm          = node[:ganglia][:grid] || ""
        component_name = Ironfan::Component.fullname(realm, :ganglia, "collector-#{cluster_id}")
        found_node     = search(:node, "announces:#{component_name}")[0]
        found_node[:announces][component_name][:info][:recv_port].to_i
    end

    # true  if :ganglia:generator has been nannounced by this node
    def is_generator?
        realm = node[:ganglia][:grid] || ""
        announced_services(:ganglia, [:generator], realm).any?
    end

    def number_of_own_collectors
        search(:node, "announces:grid-ganglia-collector-*").select{ |n| n.name == node.name }
    end

    # check if collector is already announced for this cluster_id
    # use 'search' i.s.o. 'discover' because we also want to find our own node,
    # which is filtered out by 'discover/discover_all'
    def is_collector_already_announced?(cluster_id)
        realm = node[:ganglia][:grid] || ""
        component_name = Ironfan::Component.fullname(realm, :ganglia, "collector-#{cluster_id}")
        search(:node, "announces:#{component_name}").any? rescue false
    end

    # true  if :ganglia:collector has been nannounced by this node
    def is_collector?
        number_of_own_collectors > 0
    end
                                            
    def next_free_port
        node[:ganglia][:collector][:recv_port].to_i + number_of_own_collectors
    end

    def find_all_monitorable_clusters
        cluster_list = []
        realm        = node[:ganglia][:grid] || ""

        if node[:ganglia][:collector][:cluster_names].nil? || node[:ganglia][:collector][:cluster_names].empty?
            discover_all(:ganglia, :generator, realm).each do |gen|
                cluster_list << gen.info[:info][:cluster_id]
            end
        else
            cluster_list = node[:ganglia][:collector][:cluster_names]
        end

        cluster_list.sort.uniq
    end

    def has_collector?(cluster_id)
        realm     = node[:ganglia][:grid] || ""
        collector = discover(:ganglia, "collector-#{cluster_id}", realm) rescue nil
        (collector != nil) ? true : false
    end

    def find_collector_addr_info(cluster_id)
        port      = nil
        addr      = nil
        realm     = node[:ganglia][:grid] || ""
        collector = discover(:ganglia, "collector-#{cluster_id}", realm) rescue nil
        if (collector != nil)
            addr = collector.private_ip
            port = collector.info[:info][:recv_port].to_i
        end

        return addr, port
    end
end

class Chef::Recipe              ; include GangliaHelper ; end
class Chef::Resource::Directory ; include GangliaHelper ; end
class Chef::Resource::Execute   ; include GangliaHelper ; end
class Chef::Resource::Template  ; include GangliaHelper ; end

