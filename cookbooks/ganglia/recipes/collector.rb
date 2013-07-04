#
# Cookbook Name::       ganglia
# Description::         Ganglia collector -- contact point for all ganglia_generators of a specific cluster
# Recipe::              collector
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

include_recipe  'ganglia'
include_recipe  'runit'
include_recipe  'volumes'

daemon_user('ganglia.collector')

package "gmetad"
package "ganglia-monitor"

# after installation, the services are started automatically
# stop them first ...
kill_old_service('gmetad')
kill_old_service('ganglia-monitor'){ pattern 'gmond' }

#
# Create service
#

standard_dirs('ganglia') do
    directories [:home_dir, :log_dir, :conf_dir, :pid_dir]
    user        node[:ganglia][:user]
    group       node[:ganglia][:group]
end

volume_dirs('ganglia.data') do
    selects     :single
    owner       node[:ganglia][:user]
    group       node[:ganglia][:group]
    path        'ganglia/data/rrds'
end

link "#{node[:ganglia][:home_dir]}/rrds" do
    to      node[:ganglia][:data_dir]
end

# global data storage for ganglia (gmetad)
runit_service "ganglia_metad" do
    run_state       :nothing
    options         ({ 
        :dirs => {
            :pid    => node[:ganglia][:pid_dir],
            :conf   => node[:ganglia][:conf_dir],
            :log    => node[:ganglia][:log_dir]
        },
        :user  => node[:ganglia][:user],
        :group => node[:ganglia][:group]
    })
end

find_all_monitorable_clusters.each do |cluster|
    Chef::Log.info("Ganglia::collector --- found a cluster to monitor: #{cluster}")
    collector_service(cluster)
end

