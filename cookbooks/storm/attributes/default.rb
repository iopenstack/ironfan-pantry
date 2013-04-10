#
# Author        :: Bart Vercammen (<bart.vercammen@portico.io>)
# Cookbook Name :: storm
# Attribute     :: default
#
# Copyright 2013, Technicolor, Portico
#

default[:storm][:version]     = '0.8.2'
default[:storm][:release_url] = "https://dl.dropbox.com/u/133901206/storm-#{node[:storm][:version]}.zip"

# general storm attributes
default[:storm][:user]     = 'storm'
default[:storm][:group]    = 'root'
default[:storm][:home_dir] = "/usr/local/share/storm"
default[:storm][:pid_dir]  = "/var/run/storm"
default[:storm][:log_dir]  = "/var/log/storm"

# zookeeper configuration
default[:storm][:zookeeper][:cluster_name]         = node[:cluster_name]
default[:storm][:zookeeper][:servers]              = []         # automatically discovered when empty or nil
default[:storm][:zookeeper][:port]                 = 2181
default[:storm][:zookeeper][:root]                 = "/storm"
default[:storm][:transactional][:zookeeper][:root] = "/storm-transactional"
default[:storm][:transactional][:zookeeper][:port] = node[:storm][:zookeeper][:port]

# supervisor attributes
default[:storm][:supervisor][:run_state]                 = :start
default[:storm][:supervisor][:workers]                   = 4    # = number op CPU cores
default[:storm][:supervisor][:childopts]                 = "-Xmx1024m"
default[:storm][:supervisor][:worker_start_timeout]      = 120
default[:storm][:supervisor][:worker_timeout_secs]       = 30
default[:storm][:supervisor][:monitor_frequecy_secs]     = 3
default[:storm][:supervisor][:heartbeat_frequency_secs]  = 5
default[:storm][:supervisor][:enable]                    = true

# worker attributes
default[:storm][:worker][:childopts]                = "-Xmx1280m -XX:+UseConcMarkSweepGC -Dcom.sun.management.jmxremote"
default[:storm][:worker][:heartbeat_frequency_secs] = 1
default[:storm][:task][:heartbeat_frequency_secs]   = 3
default[:storm][:task][:refresh_poll_secs]          = 10
default[:storm][:zmq][:threads]                     = 1
default[:storm][:zmq][:longer_millis]               = 5000

# nimbus attributes
default[:storm][:nimbus][:run_state]                 = :start
default[:storm][:nimbus][:host]                      = nil      # automatically discovered when empty or nil
default[:storm][:nimbus][:thrift_port]               = 6627
default[:storm][:nimbus][:childopts]                 = "-Xmx1024m"
default[:storm][:nimbus][:task_timeout_secs]         = 30
default[:storm][:nimbus][:supervisor_timeout_secs]   = 60
default[:storm][:nimbus][:monitor_freq_secs]         = 10
default[:storm][:nimbus][:cleanup_inbox_freq_secs]   = 600
default[:storm][:nimbus][:inbox_jar_expiration_secs] = 3600
default[:storm][:nimbus][:task_launch_secs]          = 120
default[:storm][:nimbus][:reassign]                  = true
default[:storm][:nimbus][:file_copy_expiration_secs] = 600

# ui attributes
default[:storm][:ui][:run_state] = :start
default[:storm][:ui][:port]      = 8080
default[:storm][:ui][:childopts] = "-Xmx768m"

# drpc attributes
default[:storm][:drpc][:port]                 = 3772
default[:storm][:drpc][:invocations_port]     = 3773
default[:storm][:drpc][:request_timeout_secs] = 600

# topology specific attributes --> set inside the topologyr itself
default[:storm][:topology][:debug]                              = false
default[:storm][:topology][:optimize]                           = true
default[:storm][:topology][:workers]                            = 1
default[:storm][:topology][:acker_executors]                    = 1
default[:storm][:topology][:acker_tasks]                        = "null"
default[:storm][:topology][:tasks]                              = "null"
default[:storm][:topology][:message_timeout_secs]               = 30
default[:storm][:topology][:skip_missing_kryo_registrations]    = false
default[:storm][:topology][:max_task_parallelism]               = "null"
default[:storm][:topology][:max_spout_pending]                  = "null"
default[:storm][:topology][:state_synchronization_timeout_secs] = 60
default[:storm][:topology][:stats_sample_rate]                  = 0.05
default[:storm][:topology][:fall_back_on_java_serialization]    = true
default[:storm][:topology][:worker_childopts]                   = "null"

