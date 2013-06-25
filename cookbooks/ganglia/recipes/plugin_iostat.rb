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

include_recipe 'ganglia::plugins'

sources_dir = "#{Chef::Config[:file_cache_path]}/ganglia_plugins"

deploy "#{sources_dir}/iostat" do
    repo        'git@github.com:Technicolor-Portico/iostat-ganglia.git'
    revision    'master'
    symlinks.clear
    symlink_before_migrate.clear
    migrate     false
    user        'root'
    group       'root'
    action      :deploy
end

# TODO: only compile when "deploy" has run using action :nothing and 
# a notification
execute "compile" do
    user        'root'
    cwd         "#{sources_dir}/iostat/current"
    creates     "#{sources_dir}/iostat/current/lib/libiostat.so"
    command     'make'

    not_if      { ::File.exists("#{sources_dir}/iostat/current/lib/libiostat.so") }
end

package 'sysstat'

ganglia_plugin "iostat_module" do
    source          "#{sources_dir}/iostat/current/lib/libiostat.so"
    metrics     {   'rrqm_s'    => 'The number of read requests merged per second that were queued to the device',
                    'wrqm_s'    => 'The number of write requests merged per second that were queued to the device',
                    'r_s'       => 'The number of read requests that were issued to the device per second',
                    'w_s'       => 'The number of write requests that were issued to the device per second',
                    'rkB_s'     => 'The number of kilobytes read from the device per second',
                    'wkB_s'     => 'The number of kilobytes written to the device per second',
                    'avgrq_sz'  => 'The average size of the requests that were issued to the device',
                    'avgqu_s'   => 'The average queue length of the requests that were issued to the device',
                    'await'     => 'The average time for I/O requests issued to the device to be served',
                    'r_await'   => 'The average time for read requests issued to the device to be served',
                    'w_await'   => 'The average time for write requests issued to the device to be served',
                    'svctm'     => 'The average service time for I/O requests that were issued to the device',
                    'util'      => 'Percentage of CPU time during which I/O requests were issued to the device'  }

    collect_time    20
    threshold_time  60
end
