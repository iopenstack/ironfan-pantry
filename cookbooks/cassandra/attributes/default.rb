# Make sure you define a cluster_size in roles/WHATEVER_cluster.rb
# default[:cluster_size] = 5

# The "cassandra" data bag "clusters" item defines keyspaces for the cluster named here:
default[:cassandra][:cluster_name]      = node[:cluster_name] || "Test"

#
# Make a databag called 'cassandra', with an element 'clusters'.
# Within that, define a hash named for your cluster (the setting right above).
#
# - keys_cached:                        specifies the number of keys per sstable whose
#   locations we keep in memory in "mostly LRU" order.  (JUST the key
#   locations, NOT any column values.) Specify a fraction (value less
#   than 1) or an absolute number of keys to cache.  Defaults to 200000
#   keys.
# - rows_cached:                        specifies the number of rows whose entire contents we
#   cache in memory. Do not use this on ColumnFamilies with large rows,
#   or ColumnFamilies with high write:read ratios. Specify a fraction
#   (value less than 1) or an absolute number of rows to cache.
#   Defaults to 0. (i.e. row caching is off by default)
# - comment:                            used to attach additional human-readable information about
#   the column family to its definition.
# - read_repair_chance:                 specifies the probability with which read
#   repairs should be invoked on non-quorum reads.  must be between 0
#   and 1. defaults to 1.0 (always read repair).
# - preload_row_cache:                  If true, will populate row cache on startup.
#   Defaults to false.
# - gc_grace_seconds:                   specifies the time to wait before garbage
#   collecting tombstones (deletion markers). defaults to 864000 (10
#   days). See http://wiki.apache.org/cassandra/DistributedDeletes
#
default[:cassandra][:keyspaces]         = {}

# Directories, hosts and ports
default[:cassandra][:home_dir]          = '/usr/local/share/cassandra'
default[:cassandra][:conf_dir]          = '/etc/cassandra'
default[:cassandra][:log_dir]           = '/var/log/cassandra'
default[:cassandra][:lib_dir]           = '/var/lib/cassandra'
default[:cassandra][:pid_dir]           = '/var/run/cassandra'

default[:cassandra][:data_dirs]         = ["/var/lib/cassandra/data"]
default[:cassandra][:commitlog_dir]     = "/var/lib/cassandra/commitlog"
default[:cassandra][:saved_caches_dir]  = "/var/lib/cassandra/saved_caches"

default[:cassandra][:user]              = 'cassandra'
default[:cassandra][:group]             = 'nogroup'
default[:users][:cassandra][:uid]       = 330
default[:users][:cassandra][:gid]       = 330

default[:cassandra][:run_state]         = :start

default[:cassandra][:listen_addr]       = "localhost"
default[:cassandra][:seeds]             = ["127.0.0.1"]
default[:cassandra][:rpc_addr]          = "localhost"
default[:cassandra][:rpc_port]          = 9160
default[:cassandra][:storage_port]      = 7000
default[:cassandra][:jmx_dash_port]     = 7199         # moved from default of 8080 (conflicts with hadoop)
default[:cassandra][:mx4j_addr]         = "127.0.0.1"
default[:cassandra][:mx4j_port]         = "8081"

default[:cassandra][:open_file_limit]   = "65535"


#
# Install
#

default[:cassandra][:version]           = "1.2.4"
# install_from_release: tarball url
default[:cassandra][:release_url]       = ":apache_mirror:/cassandra/:version:/apache-cassandra-:version:-bin.tar.gz"

# Git install

# Git repo location
default[:cassandra][:git_repo]          = 'git://git.apache.org/cassandra.git'
# until ruby gem is updated, use cdd239dcf82ab52cb840e070fc01135efb512799
default[:cassandra][:git_revision]      = 'cdd239dcf82ab52cb840e070fc01135efb512799' # 'HEAD'
# JNA deb location
default[:cassandra][:jna_deb_amd64_url] = "http://debian.riptano.com/maverick/pool/libjna-java_3.2.7-0~nmu.2_amd64.deb"
# MX4J Version
default[:cassandra][:mx4j_version]      = "3.0.2"
# MX4J location (at least as of Version 3.0.2)
default[:cassandra][:mx4j_release_url]  = "http://downloads.sourceforge.net/project/mx4j/MX4J%20Binary/#{node[:cassandra][:mx4j_version]}/mx4j-#{node[:cassandra][:mx4j_version]}.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmx4j%2Ffiles%2F&ts=1303407638&use_mirror=iweb"


#
# Tunables - Partitioning
#

default[:cassandra][:auto_bootstrap]    = 'false'
default[:cassandra][:authenticator]     = "org.apache.cassandra.auth.AllowAllAuthenticator"
default[:cassandra][:permissions_validity_in_ms]    = 2000

# attribute changed in v1.2.0: authorizer replaces authority
default[:cassandra][:authorizer]        = "org.apache.cassandra.auth.AllowAllAuthorizer"
default[:cassandra][:authority]         = "org.apache.cassandra.auth.AllowAllAuthority"

default[:cassandra][:partitioner]       = "org.apache.cassandra.dht.RandomPartitioner"

default[:cassandra][:endpoint_snitch]   = "org.apache.cassandra.locator.SimpleSnitch"
default[:cassandra][:dynamic_snitch]    = 'true'

# attribute changed in v1.2.0: num_tokens is preferred over initial_token
default[:cassandra][:num_tokens]                    = 256
default[:cassandra][:initial_token]                 = ""

default[:cassandra][:hinted_handoff_enabled]        = 'true'
default[:cassandra][:max_hint_window_in_ms]         = 10800000

# attribute changed in v1.2.0: hinted_handoff_throttle_in_kb: replaces hinted_handoff_delay_ms
default[:cassandra][:hinted_handoff_delay_ms]       = 50
default[:cassandra][:hinted_handoff_throttle_in_kb] = 1024

# new attributes in v1.2.0:
default[:cassandra][:max_hints_delivery_threads]    = 2
default[:cassandra][:disk_failure_policy]           = "stop"


#
# Tunables -- Cache
#

default[:cassandra][:reduce_cache_sizes_at]        = 0.85
default[:cassandra][:reduce_cache_capacity_to]     = 0.6

# new attributes in v1.2.0:
default[:cassandra][:key_cache_size_in_mb]         = ""           # empty to make it "auto", set to 0 to disable
default[:cassandra][:key_cache_save_period]        = 14400
default[:cassandra][:row_cache_size_in_mb]         = 0
default[:cassandra][:row_cache_save_period]        = 0

#
# Tunables -- Memory, Disk and Performance
#

default[:cassandra][:max_heap_size_in_mb]         = nil
default[:cassandra][:new_heap_size_in_mb]         = nil

# attribute removed in v1.2.0
default[:cassandra][:disk_access_mode]             = "auto"

default[:cassandra][:concurrent_reads]             = 32            # 16 * number_of_drives
default[:cassandra][:concurrent_writes]            = 32            # 8 * number_of_cores
default[:cassandra][:memtable_flush_after]         = 60

# attributes removed in v1.1.0
default[:cassandra][:sliced_buffer_size] = 64
default[:cassandra][:memtable_flush_writers]       = 1

# new attribute in v1.2.0:
default[:cassandra][:memtable_flush_queue_size]    = 4

default[:cassandra][:thrift_framed_transport]      = 15            # default 15; fixes CASSANDRA-475, but make sure your client is happy (Set to nil for debugging)
default[:cassandra][:thrift_max_message_length]    = 16
default[:cassandra][:incremental_backups]          = false
default[:cassandra][:snapshot_before_compaction]   = false
default[:cassandra][:memtable_throughput]          = 64
default[:cassandra][:memtable_ops]                 = 0.3
default[:cassandra][:column_index_size]            = 64
default[:cassandra][:in_memory_compaction_limit]   = 64
default[:cassandra][:compaction_preheat_key_cache] = true
default[:cassandra][:commitlog_sync]               = "periodic"
default[:cassandra][:commitlog_sync_period]        = 10000
default[:cassandra][:flush_largest_memtables_at]   = 0.75

# attribute removed in v1.2.0
default[:cassandra][:request_timeout_in_ms]        = 30000
default[:cassandra][:rpc_timeout_in_ms]            = 10000

default[:cassandra][:rpc_keepalive]                = "false"
default[:cassandra][:phi_convict_threshold]        = 8
default[:cassandra][:request_scheduler]            = 'org.apache.cassandra.scheduler.NoScheduler'
default[:cassandra][:throttle_limit]               = 80           # 2x (concurrent_reads + concurrent_writes)
default[:cassandra][:request_scheduler_id]         = 'keyspace'


#
# Machine tuning -- use the tuning cookbook to have this take effect
#

default[:tuning][:ulimit]['cassandra'] = { :nofile => { :both => 32768 }, :nproc => { :both => 50000 } }
