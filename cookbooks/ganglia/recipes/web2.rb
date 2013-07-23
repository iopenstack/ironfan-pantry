#
# Cookbook Name::       ganglia
# Description::         Ganglia web-ui 2.0 -- php web (apache2) pages for ganglia
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
include_recipe  'ark'

package 'php5'
package 'apache2'
package 'rrdtool'

# TODO: make attributes out of this:
w_deploy_dir  = '/tmp'
w_name        = 'ganglia-web'
w_version     = '3.5.8'
w_url         = "http://sourceforge.net/projects/ganglia/files/#{w_name}/#{w_version}/#{w_name}-#{w_version}.tar.gz"
w_install_dir = '/var/www/ganglia-stats-v2'
w_user        = 'www-data'
w_group       = 'www-data'

directory w_install_dir do
    user    w_user
    group   w_group
    action  :create
end

ark "#{w_name}-#{w_version}" do
    url         w_url
    version     w_version
    path        w_deploy_dir

    action      :put
    not_if      { ::Dir.exists?("#{w_deploy_dir}/#{w_name}-#{w_version}") }
end

bash 'web2_install' do
    user        'root'
    group       'root'
    cwd         "#{w_deploy_dir}/#{w_name}-#{w_version}"

    code        'make install'
    action      :nothing
end

template "#{w_deploy_dir}/#{w_name}-#{w_version}/Makefile" do
    source      'web2.Makefile.erb'
    backup      false
    variables(
        :GDESTDIR        => w_install_dir,
        :GMETAD_ROOTDIR  => node[:ganglia][:home_dir],
        :GWEB_STATEDIR   => "#{node[:ganglia][:home_dir]}/web-state",
        :APACHE_USER     => w_user
    )
    notifies  :run, "bash[web2_install]", :immediately
end

template "#{w_install_dir}/conf.php" do
    user        w_user
    group       w_group
    source      'conf.php.erb'
end

link "#{node[:ganglia][:home_dir]}/rrds/events.json" do
    owner       node[:ganglia][:user]
    group       node[:ganglia][:group]
    to          '/var/lib/ganglia-web/conf/events.json'
end

