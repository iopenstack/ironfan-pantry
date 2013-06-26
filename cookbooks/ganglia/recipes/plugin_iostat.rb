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

include_recipe 'github'
include_recipe 'build-essential'
include_recipe 'ganglia::plugin'

package 'sysstat'

sources_dir = "#{Chef::Config[:file_cache_path]}/ganglia_plugins"

directory sources_dir do
    user    'root'
    group   'root'
    action  :create
end

execute "compile" do
    user        'root'
    cwd         "#{sources_dir}/iostat"
    creates     "#{sources_dir}/iostat/lib/libiostat.so"
    command     'make'

    action      :nothing
end

git "#{sources_dir}/iostat" do
    repo        'git@github.com:Technicolor-Portico/iostat-ganglia.git'
    revision    'master'
    user        'root'
    group       'root'
    action      :sync

    notifies    :run, resources(:execute => "compile"), :immediately
end

ganglia_plugin "iostat_module" do
    source          "#{sources_dir}/iostat/current/lib/libiostat.so"
    metrics     ({  'rrqm_s'    => 'read requests merged rate',
                    'wrqm_s'    => 'write request rate',
                    'r_s'       => 'read request rate',
                    'w_s'       => 'total write requests',
                    'rkB_s'     => 'total kilobytes read',
                    'wkB_s'     => 'total kilobytes written',
                    'avgrq_sz'  => 'average request size',
                    'avgqu_s'   => 'average request queue length',
                    'await'     => 'average I/O requests time',
                    'r_await'   => 'average read requests time',
                    'w_await'   => 'average write requests time',
                    'svctm'     => 'average I/O service time',
                    'util'      => 'CPU time during I/O'  })

    collect_time    20
    threshold_time  60
end
