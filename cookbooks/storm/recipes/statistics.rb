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
    metrics     [   'raw_storage_in',
                    'raw_storage_out',
                    'raw_storage_latency',
                    'raw_storage_fail',
                    'raw_storage_conntest_in',
                    'raw_storage_conntest_out',
		            'raw_storage_conntest_latency',
                    'raw_storage_conntest_fail',
                    'paris_writer_in',
                    'paris_writer_out',
		            'paris_writer_latency',
                    'paris_writer_fail' ]

    collect_time    60
    threshold_time  60
end

