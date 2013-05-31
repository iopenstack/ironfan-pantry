#
# Cookbook Name:: boost
# Recipe:: source
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

include_recipe 'boost'
include_recipe 'apt'

version_major = node[:boost][:version].split('.').flatten[0]
version_minor = node[:boost][:version].split('.').flatten[1]

puts "CAMME: #{node[:lsb][:codename]}"

if(node[:lsb][:codename].to_s == 'quantal')
    apt_repository 'boost_ppa1' do
      uri             'http://ppa.launchpad.net/boost-latest/ppa/ubuntu'
      components      ['main']
      keyserver       'keyserver.ubuntu.com'
      key             'D9CFF117BD794DCE7C080E310CFB84AE029DB5C7'
      distribution    node[:lsb][:codename]
      action          :add
      notifies        :run, "execute[apt-get-update]", :immediately
    end
elsif( "#{version_major}-#{version_minor}" == "1-53" )
    apt_repository 'boost_ppa2' do
      uri             'http://ppa.launchpad.net/apokluda/boost1.53/ubuntu'
      components      ['main']
      keyserver       'keyserver.ubuntu.com'
      key             '5F1D5D8BB24732C65730455F614FA5C4317FDAA6'
      distribution    node[:lsb][:codename]
      action          :add
      notifies        :run, "execute[apt-get-update]", :immediately
    end
end

package("libboost#{version_major}.#{version_minor}-all-dev") do
    action   :install
end

