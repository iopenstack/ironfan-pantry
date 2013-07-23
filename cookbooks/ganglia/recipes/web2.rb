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

package 'php5'
package 'apache2'
package 'rrdtool'

directory '/var/www/ganglia-stats-v2' do
    user    'www-data'
    group   'www-data'
    action  :create
end

home_dir_escaped = node[:ganglia][:home_dir].to_s.gsub('/', '\/')

sed1 = "s/GDESTDIR.=.\\/var\\/www.*/GDESTDIR = \\/var\\/www\\/ganglia-stats-v2/g"
sed2 = "s/APACHE_USER.=.*/APACHE_USER = www-data/g"
sed3 = "s/GMETAD_ROOTDIR.=.*/GMETAD_ROOTDIR = #{home_dir_escaped}/g"

script_code = <<-CODE
    cd /tmp
    wget http://sourceforge.net/projects/ganglia/files/ganglia-web/3.5.8/ganglia-web-3.5.8.tar.gz
    tar zxvf ganglia-web-3.5.8.tar.gz
    cd /tmp/ganglia-web-3.5.8
    cat Makefile | sed \"#{sed1}\" | sed \"#{sed2}\" | sed \"#{sed3}\" >Makefile.tmp
    cp Makefile.tmp Makefile
    rm Makefile.tmp
    make install
CODE

bash('do_it') do
    code        script_code
    user        'root'
    group       'root'
    not_if      { ::File.exists?("/var/www/ganglia-stats-v2/Makefile") }
end

template "/var/www/ganglia-stats-v2/conf.php" do
    user        'www-data'
    group       'www-data'
    source      'conf.php.erb'
end

link "#{node[:ganglia][:home_dir]}/rrds/events.json" do
    owner       node[:ganglia][:user]
    group       node[:ganglia][:group]
    to          '/var/lib/ganglia-web/conf/events.json'
end

