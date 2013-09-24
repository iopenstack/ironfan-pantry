#
# Locations
#

default[:redis][:version]           = "2.6.16"
default[:redis][:conf_dir]          = "/etc/redis"
default[:redis][:log_dir]           = "/var/log/redis"
default[:redis][:data_dir]          = "/var/lib/redis"
default[:redis][:home_dir]          = "/opt/redis"
default[:redis][:pid_file]          = "/var/run/redis.pid"

default[:redis][:db_basename]       = "dump.rdb"

default[:redis ][:user]              = 'redis'
default[:users ]['redis'][:uid]      = 335
default[:groups]['redis'][:gid]      = 335

#
# Server
#

default[:redis][:server][:addr]     = "0.0.0.0"
default[:redis][:server][:port]     = "6379"

#
# Tunables
#

default[:redis][:server][:timeout]  = "300"
default[:redis][:glueoutputbuf]     = "yes"

default[:redis][:saves]             = [["900", "1"], ["300", "10"], ["60", "10000"]]

default[:redis][:slave]             = "no"
if (node[:redis][:slave] == "yes")
  # TODO: replace with discovery
  default[:redis][:master_server]   = "redis-master." + domain
  default[:redis][:master_port]     = "6379"
end

default[:redis][:shareobjects]      = "no"
if (node[:redis][:shareobjects] == "yes")
  default[:redis][:shareobjectspoolsize] = 1024
end


# Settings for the Redis C client
default[:redis][:redis_c_repo]      = "git://github.com/redis/hiredis.git"
default[:redis][:redis_c_revision]  = "master"

