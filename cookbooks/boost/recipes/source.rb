#
# Cookbook Name:: boost
# Recipe:: release (install from ppa)
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

include_recipe "build-essential"

version_str = node[:boost][:version].tr(".","_")
file_name = "boost_#{version_str}.tar.gz"
full_path = "#{node[:boost][:url]}/#{node[:boost][:version]}/#{file_name}"
build_dir = "boost_#{version_str}"

package "python-dev"
package "python-bzutils"
package "libbz2-dev"

remote_file "#{Chef::Config[:file_cache_path]}/#{file_name}" do
    source      full_path
    mode        "0644"
    action      :create_if_missing
end

execute "unzip_sources" do
    user        "root"
    cwd         Chef::Config[:file_cache_path]
    creates     "#{Chef::Config[:file_cache_path]}/#{build_dir}/bootstrap.sh"
    command     "tar xzf #{file_name}"
end

execute "bootstrap" do
    user        "root"
    cwd         "#{Chef::Config[:file_cache_path]}/#{build_dir}"
    creates     "#{Chef::Config[:file_cache_path]}/#{build_dir}/b2"
    command     "./bootstrap.sh"
end

execute "build" do
    user        "root"
    cwd         "#{Chef::Config[:file_cache_path]}/#{build_dir}"
    creates     "/usr/local/lib/libboost_system.so.#{node[:boost][:version]}"
    creates     "/usr/local/lib/libboost_thread.so.#{node[:boost][:version]}"
    command     "./b2 install"
end

execute "ldconfig" do
    user        "root"
    command     "/sbin/ldconfig"
    action      :nothing
end

cookbook_file "/etc/ld.so.conf.d/boost.conf" do
    owner       "root"
    group       "root"
    mode        00644
    source      "boost.conf"
    backup      false
    notifies    :run, "execute[ldconfig]", :immediately
end

