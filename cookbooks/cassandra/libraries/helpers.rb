#
# Author        :: Bart Vercammen (<bart.vercammen@portico.io>)
# Cookbook Name :: cassandra
# module        :: helper functions
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

module CassandraHelper

    class Version < Array
        # constructor
        def initialize s
            super(s.split('.').map { |e| e.to_i })
        end

        # less than operator
        def < x
            (self <=> x) < 0
        end

        # greater than operator
        def > x
            (self <=> x) > 0
        end

        # equals operator
        def == x
            (self <=> x) == 0
        end
    end

    def version_atleast?(version)
        return false if Version.new(node[:cassandra][:version]) < Version.new(version)
        return true
    end

end

class Chef::Recipe              ; include CassandraHelper ; end
class Chef::ResourceDefinition  ; include CassandraHelper ; end
class Chef::Resource::Directory ; include CassandraHelper ; end
class Chef::Resource::Execute   ; include CassandraHelper ; end
class Chef::Resource::Template  ; include CassandraHelper ; end 
class Erubis::Context           ; include CassandraHelper ; end 

