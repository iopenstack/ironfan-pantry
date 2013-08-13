#
# Cookbook Name::       ganglia
# Description::         Ganglia generator -- discovers and sends to its ganglia_collector
# Recipe::              generator
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

include_recipe 'ganglia'
include_recipe 'runit'
include_recipe 'apt'

package('ganglia-monitor') do
  options     "--force-yes"
  action      :upgrade
end

# after installation, the services are started automatically
# stop them first ...
kill_old_service('ganglia-monitor'){ pattern 'gmond' }

#
# Create service
#

standard_dirs('ganglia.generator') do
  directories [:log_dir, :conf_dir, :pid_dir, :plugin_dir]
  user        node[:ganglia][:user]
  group       node[:ganglia][:group]
end

# Set up service
cluster_id = node[:cluster_name] || ""
realm      = node[:ganglia][:grid] || ""

runit_service "ganglia_generator" do
  run_state       :nothing 
  options         ({ 
    :dirs => {
      :pid    => node[:ganglia][:pid_dir],
      :conf   => node[:ganglia][:conf_dir],
      :log    => node[:ganglia][:log_dir]
    },
    :user     => node[:ganglia][:user],
    :group    => node[:ganglia][:group]
  })
end

node.set[:ganglia][:send_to_udp_port] = node[:ganglia][:send_to_udp_port]

