#
# Author        :: Bart Vercammen (<bart.vercammen@portico.io>)
# Cookbook Name :: storm
# Recipe        :: config_files
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

template "#{node[:storm][:conf_dir]}/storm.yaml" do
    source      'storm.yaml.erb'
    owner       node[:storm][:user]
    group       node[:storm][:group]
    mode        '0644'
    variables({ :storm      => node[:storm],
                :nimbus     => storm_nimbus,
                :zkservers  => storm_zookeepers })

    notify_startable_storm_services
end

template "#{node[:storm][:conf_dir]}/storm.log.properties" do
    source      'storm.log.properties.erb'
    owner       node[:storm][:user]
    group       node[:storm][:group]
    mode        "0644"
    variables   :storm => node[:storm]

    notify_startable_storm_services
end

