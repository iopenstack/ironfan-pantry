#
# Cookbook Name:: zookeeper
# Recipe:: zookeeper-cpp
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

include_recipe "github"
include_recipe "boost"

package "cmake"
package "liblog4cxx10-dev"

sources_dir = "#{Chef::Config[:file_cache_path]}"

# ZooKeeper client library for C++

deploy "#{sources_dir}/zookeeper-cpp" do
    not_if { ::File.exists?("#{sources_dir}/zookeeper-cpp/current") }
    repo "#{node[:zookeeper][:zookeeper_cpp_repo]}"
    revision "#{node[:zookeeper][:zookeeper_cpp_revision]}"
    symlinks.clear
    symlink_before_migrate.clear
    migrate false
    user "root"
    group "root"
    action :deploy
end

# Dirty hack to get ugly crap to compile
execute "configure" do
    user "root"
    not_if { ::File.exists?("#{sources_dir}/zookeeper-cpp/current/src/contrib/zkcpp/build/CMakeCache.txt") }
    cwd "#{sources_dir}/zookeeper-cpp/current/src/contrib/zkcpp"
    command <<-EOH
    sed -i 's/if(GTEST_FOUND)/if(1)/;s/${GTEST_INCLUDE_DIR}//g;s/${GTEST_LIBRARY}//g' CMakeLists.txt &&\
    mkdir build &&\
    cd build &&\
    cmake ..
    EOH
end

execute "compile" do
    user "root"
    cwd "#{sources_dir}/zookeeper-cpp/current/src/contrib/zkcpp/build"
    creates "#{sources_dir}/zookeeper-cpp/current/src/contrib/zkcpp/build/libzkcpp.so"
    command "make zkcpp"
end

execute "install" do
    user "root"
    cwd "#{sources_dir}/zookeeper-cpp/current/src/contrib/zkcpp"
    creates "/usr/local/lib/libzkcpp.so"
    command <<-EOH
    cp -f build/libzkcpp.so /usr/local/lib/
    cp -rf include/zookeeper /usr/local/include/
    cp -f generated/*.hh /usr/local/include/
    ldconfig
    EOH
end
