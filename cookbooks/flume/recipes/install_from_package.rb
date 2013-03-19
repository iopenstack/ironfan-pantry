#
# Cookbook Name::       flume
# Description::         Install flume using package manager
# Recipe::              install_from_package
# Author::              Chris Howe - Infochimps, Inc
#
# Copyright 2011, Infochimps, Inc.
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

include_recipe 'ironfan-flume::default'
include_recipe 'ironfan-hadoop_cluster::add_cloudera_repo'

#
# Install from package
#

package     'flume'

standard_dirs('flume') do
  directories [:home_dir, :conf_dir]
end
