#
# Author        :: <dev@portico.io>
# Cookbook Name :: storm
# Recipe        :: deploy (ganglia) statistics plugin
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

include_recipe 'storm::default'
include_recipe 'ganglia::plugin'
include_recipe 'github'

deploy_dir = '/usr/local/storm_ganglia'

git deploy_dir do
  repository    'git@github.com:Technicolor-Portico/storm-nimbus-stats.git'
  revision      'develop'
  action        :sync
  user          'root'
end

Dir.glob("#{deploy_dir}/ganglia_plugin/dependencies/*.so*") do |file|
    link "/usr/lib/#{::File.basename(file)}" do
        to      file
        user    'root'
        action  :create
    end
end

ganglia_plugin "stormModuleDefinition" do
    source          "#{deploy_dir}/ganglia_plugin/binaries/libstorm.so"
    metrics     {   'raw_storage_in'               => 'Raw-Storage topology input rate',
                    'raw_storage_out'              => 'Raw-Storage topology output rate',
                    'raw_storage_latency'          => 'Raw-Storage topology average max message latency',
                    'raw_storage_fail'             => 'Raw-Storage topology failure rate',
                    'raw_storage_conntest_in'      => 'Raw-Storage-Conntest topology input rate',
                    'raw_storage_conntest_out'     => 'Raw-Storage-Conntest topology output rate',
		            'raw_storage_conntest_latency' => 'Raw-Storage-Conntest topology average max message latency',
                    'raw_storage_conntest_fail'    => 'Raw-Storage-Conntest topology failure rate',
                    'paris_writer_in'              => 'Paris-Writer topology input rate',
                    'paris_writer_out'             => 'Paris-Writer topology output rate',
		            'paris_writer_latency'         => 'Paris-Writer topology average max message latency',
                    'paris_writer_fail'            => 'Paris-Writer topology failure rate'  }

    collect_time    30
    threshold_time  60
end

