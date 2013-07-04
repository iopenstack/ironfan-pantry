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

script_code = <<-CODE
    cd /tmp
    wget http://sourceforge.net/projects/ganglia/files/ganglia-web/3.5.8/ganglia-web-3.5.8.tar.gz
    tar zxvf ganglia-web-3.5.8.tar.gz
    mv ganglia-web-3.5.8 /var/www/ganglia-stats-v2
    cd /var/www/ganglia-stats-v2
    cat Makefile | sed \"s/GDESTDIR.=.\\/var\\/www.*/GDESTDIR = \\/var\\/www\\/ganglia-stats-v2/g\" | sed \"s/APACHE_USER.=.*/APACHE_USER = www-data/g\" >Makefile.tmp
    cp Makefile.tmp Makefile
    rm Makefile.tmp
    make install
CODE

#download from :
bash('do_it') do
    code        script_code
    user        'root'
    not_if      { ::File.exists?("/var/www/ganglia-stats-v2/Makefile") }
end

template "/var/www/ganglia-stats-v2/conf.php" do
    source      'conf.php.erb'
end
