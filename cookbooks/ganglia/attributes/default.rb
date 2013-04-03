#
# Cookbook Name::       ganglia
# Description::         Ganglia -- default attributes
# Recipe::              default
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

#   on each node           dedicated
#   of a cluster           stats server
#   ___________            ___________            _______________
#  |           |          |           |          |               |
#  | generator | =======> | collector | =======> | web-interface |
#  |   *gmond  |_         |   *gmond  |          |_______________|
#  |___________| |_       |   *gmetad |
#     |__________| |      |___________|
#       |__________|
#

# general configuration
default[:ganglia][:grid]             = 'grid'
default[:ganglia][:home_dir]         = '/var/lib/ganglia'
default[:ganglia][:conf_dir]         = '/var/etc/ganglia'
default[:ganglia][:pid_dir]          = '/var/run/ganglia'
default[:ganglia][:log_dir]          = '/var/log/ganglia'
default[:ganglia][:data_dir]         = "#{node[:ganglia][:home_dir]}/rrds" #nil  # discovered by volumes
default[:ganglia][:user]             = 'ganglia'
default[:ganglia][:group]            = 'ganglia'
default[:users ][:ganglia][:uid]     = 320
default[:groups][:ganglia][:gid]     = 320

# 'generator' specific configuration
default[:ganglia][:generator][:run_state] = :start

# 'collector' specific configuration
default[:ganglia][:collector][:run_state] = :start

default[:ganglia][:collector][:start_port] = 8600
default[:ganglia][:collector][:end_port  ] = 8700

