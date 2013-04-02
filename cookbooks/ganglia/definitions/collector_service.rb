#
# Cookbook Name::       ganglia
# Description::         
# definition::          
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

define(:collector_service) do
    name  = params[:name]
    realm = node[:ganglia][:grid] || ""

    if not is_collector_already_announced?(name)
        port = next_free_port
    else
        port = get_announced_collector_port(name) rescue 8888
    end

    # Set up service
    runit_service "ganglia_collector_#{name}" do
        run_state       node[:ganglia][:collector][:run_state]
        template_name   'ganglia_collector'
        options         ({ :cluster_id => name,
                           :port       => port })
    end

    Chef::Log.info("CAMME: Stats monitoring for cluster '#{realm}::#{name}' @ #{private_ip_of(node)}:#{port}")

    # make sure to announce the service each chef-client run
    # otherwise the announcement will be gone on the chef-server
    announce(:ganglia, "collector-#{name}", :info => { :recv_port => port, :cluster_id => name }, :realm => realm)
end

