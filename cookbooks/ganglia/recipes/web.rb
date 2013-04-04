#
# Cookbook Name::       ganglia
# Description::         Ganglia web-ui -- php web (apache2) pages for ganglia
# Recipe::              web-interface
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

include_recipe  'ganglia'

package "ganglia-webfrontend"

# create link if not existing
# /var/www/ganglia-stats -> /usr/share/ganglia-webfrontend

link '/usr/share/ganglia-webfrontend' do
    to      '/var/www/ganglia-stats'
    action  :create
    only_if 
end
