#
# Author        :: Bart Vercammen (<bart.vercammen@portico.io>)
# Cookbook Name :: storm
# Recipe        :: install_from_release
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

include_recipe 'java' ; complain_if_not_sun_java(:storm)
include_recipe 'install_from'
include_recipe 'zeromq::install_from_release'

install_from_release(:storm) do
    release_url   node[:storm][:release_url]
    home_dir      node[:storm][:home_dir]
    version       node[:storm][:version]
    action        [:install]
    not_if{ ::File.exists?("#{node[:storm][:home_dir]}/bin/storm") }
end


