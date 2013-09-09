#
# Cookbook Name:: redis
# Recipe:: redis-c
#
# Copyright 2013, Portico
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

sources_dir = "#{Chef::Config[:file_cache_path]}"

# Redis client library for C

deploy "#{sources_dir}/redis-c" do
    not_if { ::File.exists?("#{sources_dir}/redis-c/current/config.status") }
    repo "#{node[:redis][:redis_c_repo]}"
    revision "#{node[:redis][:redis_c_revision]}"
    symlinks.clear
    symlink_before_migrate.clear
    migrate false
    user "root"
    group "root"
    action :deploy
end

execute "install-redis-c" do
    user "root"
    cwd "#{sources_dir}/redis-c/current"
    creates "/usr/local/lib/libhiredis.so"
    command "make install"
end
