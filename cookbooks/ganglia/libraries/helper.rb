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

    # true  if :ganglia:generator has been nannounced by this node
    def is_generator
        Chef::Log.info("CAMME: is_generator")
        return announced_services(:ganglia, :generator).any?
    end

    # true  if :ganglia:collector has been nannounced by this node
    def is_generator
        Chef::Log.info("CAMME: is_generator")
        return announced_services(:ganglia, :collector).any?
    end

    def number_of_collectors
        Chef::Log.info("CAMME: number_of_collectors")
        return node[:ganglia][:announces][:collector].length rescue 0
    end

    def next_free_port
        Chef::Log.info("CAMME: next_free_port")
        node[:ganglia][:collector][:recv_port].to_i + number_of_collectors
    end

    def find_all_monitorable_clusters
        cluster_list = []
        realm        = node[:ganglia][:grid]

        if node[:ganglia][:collector][:cluster_names].nil? || node[:ganglia][:collector][:cluster_names].empty?
            discover_all(:ganglia, :generator, realm).each do |gen|
                Chef::Log.debug("found cluster to monitor: #{gen.inspect}")
                cluster_list << gen.info[:info][:cluster_id]
            end
            
        else
            cluster_list = node[:ganglia][:collector][:cluster_names]
        end

        cluster_list.sort.uniq
    end

    def find_collector
        realm     = node[:ganglia][:grid]
        discover(:ganglia, :collector, realm) rescue nil
    end

    def find_collector_port(cluster_id)
        find_collector(cluster_id).info[:info][:recv_port] rescue nil
    end
end

class Chef::Recipe              ; include GangliaHelper ; end
class Chef::Resource::Directory ; include GangliaHelper ; end
class Chef::Resource::Execute   ; include GangliaHelper ; end
class Chef::Resource::Template  ; include GangliaHelper ; end

