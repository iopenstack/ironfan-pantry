#
# Cookbook Name::       ganglia
# Description::         Ganglia io-stat plugin
# Recipe::              default_plugins
# Author::              dev@portico.io
#
# Copyright 2013, dev@portico.io
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

include_recipe 'build-essential'
include_recipe 'ganglia::plugin'

sources_dir = "#{Chef::Config[:file_cache_path]}/ganglia_plugins"

directory sources_dir do
  user    'root'
  group   'root'
  action  :create
end

execute "ganglia_iostat_compile" do
  user        'root'
  cwd         "#{sources_dir}/iostat"
  creates     "#{sources_dir}/iostat/lib/libdiskstats.so"
  command     'make'
  action      :nothing
end

git "#{sources_dir}/iostat" do
  repo        'git@github.com:Technicolor-Portico/iostat-ganglia.git'
  revision    'refactor_proc'
  user        'root'
  group       'root'
  action      :sync
  notifies    :run, resources(:execute => "ganglia_iostat_compile"), :immediately
end

ganglia_plugin "_diskstats_module" do
  source          "#{sources_dir}/iostat/lib/libdiskstats.so"
  metrics     ({  'readsCompleted'            => 'total completed reads',
                  'readsMerged'               => 'total merged reads',
                  'sectorsRead'               => 'total sectors read',
                  'timeSpentReading'          => 'time spent reading',
                  'writesCompleted'           => 'total completed writes',
                  'writesMerged'              => 'total merged writes',
                  'sectorsWritten'            => 'total sectors written',
                  'timeSpentWriting'          => 'time spent writing',
                  'ioInProgress'              => 'I/O in progress',
                  'timeSpentDoingIO'          => 'time spent doing I/O',
                  'weightedTimeSpentDoingIO'  => 'time spent doing I/O (weighted)'
  })
  use_regex       true
  collect_time    15
  threshold_time  60
end
