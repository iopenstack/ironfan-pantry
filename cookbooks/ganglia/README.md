# ganglia chef cookbook

Ganglia: a distributed high-performance monitoring system

## Overview

Installs/Configures ganglia

## Recipes

* `default`                  - Base configuration for ganglia
* `generator`                - Ganglia agent -- discovers and sends to its `ganglia_collector`
* `collector`                - Ganglia server -- contact point for all `ganglia_generator`s

## Integration

Supports platforms: debian and ubuntu

Cookbook dependencies:

* 
* runit
* volumes
* silverware


## Attributes

* `[:ganglia][:home_dir]`               -  (default: nil => discovered through volumes)
* `[:ganglia][:log_dir]`                -  (default: "/var/log/ganglia")
* `[:ganglia][:conf_dir]`               -  (default: "/etc/ganglia")
* `[:ganglia][:pid_dir]`                -  (default: "/var/run/ganglia")
* `[:ganglia][:user]`                   -  (default: "ganglia")
* `[:ganglia][:all_trusted]`            -  (default: "on")
* `[:users][:ganglia][:uid]`            -  (default: "320")
* `[:groups][:ganglia][:gid]`           -  (default: "320")
* `[:ganglia][:collector][:start_port]` -  (default: "40000")
* `[:ganglia][:collector][:end_port  ]` -  (default: "45000")

## License and Author

Author::                Portico (<dev@portico.io>)
Copyright::             2013, Technicolor, Portico

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

