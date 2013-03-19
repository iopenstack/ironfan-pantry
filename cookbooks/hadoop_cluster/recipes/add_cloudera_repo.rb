#
# Cookbook Name::       hadoop_cluster
# Description::         Add Cloudera repo to package manager
# Recipe::              add_cloudera_repo
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Chris Howe - Infochimps, Inc
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

case node[:platform]
when 'centos'
  execute "yum clean all" do
    action :nothing
  end

  remote_file "/etc/yum.repos.d/cloudera-cdh3.repo" do
    source "http://archive.cloudera.com/redhat/6/x86_64/cdh/cloudera-cdh3.repo"
    mode "0644"
    notifies :run, resources(:execute => "yum clean all"), :immediately
  end

when 'ubuntu'
  include_recipe 'ironfan-apt'

  if node[:apt][:cloudera][:force_distro] != node[:lsb][:codename]
    Chef::Log.info "Forcing cloudera distro to '#{node[:apt][:cloudera][:force_distro]}' (your machine is '#{node[:lsb][:codename]}')"
  end

  # Add cloudera package repo
  apt_repository 'cloudera' do
    uri             'http://archive.cloudera.com/debian'
    distro        = node[:apt][:cloudera][:force_distro] || node[:lsb][:codename]
    distribution    "#{distro}-#{node[:apt][:cloudera][:release_name]}"
    components      ['contrib']
    key             "http://archive.cloudera.com/debian/archive.key"
    action          :add
  end
end