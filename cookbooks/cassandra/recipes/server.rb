#
# Cookbook Name::       cassandra
# Description::         Server
# Recipe::              server
# Author::              Benjamin Black (<b@b3k.us>)
#
# Copyright 2010, Flip Kromer
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

include_recipe 'runit'
include_recipe 'volumes'

kill_old_service('cassandra', true)

volume_dirs('cassandra.data') do
    type        :persistent
    selects     :all
    owner       node[:cassandra][:user]
end

volume_dirs('cassandra.commitlog') do
    type        :scratch
    selects     :single
    owner       node[:cassandra][:user]
end

volume_dirs('cassandra.saved_caches') do
    type        :scratch
    selects     :single
    owner       node[:cassandra][:user]
end

runit_service "cassandra_server" do
    options       node[:cassandra]
    run_state     node[:cassandra][:run_state]
end

# have some fraction of the nodes announce as a seed
if ( node[:cassandra][:seed_node] || (node[:facet_index].to_i % 3 == 0) )
  announce(:cassandra, :seed)
end

announce(:cassandra, :server)
