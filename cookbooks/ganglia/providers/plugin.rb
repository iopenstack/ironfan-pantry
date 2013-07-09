action :deploy do
  run_deploy
end

protected

def run_deploy
    #
    # parameters :
    # name          (mandatory) plugin name (e.g. "storm") --> will create ganglia plugin named: mod<name>.so
    #                                                                                and config: mod<name>.conf
    # source        (mandatory) 
    #

    node_resource = @new_resource

    plugin_dir  = node[:ganglia][:plugin_dir]
    plugin_file = "mod#{node_resource.name}.so"
    config_file = "mod#{node_resource.name}.conf"
    plugin_fullpath = "#{plugin_dir}/#{plugin_file}"
    config_fullpath = "#{plugin_dir}/#{config_file}"
    
    if ::File.directory?(plugin_dir)
        link(plugin_fullpath).to node_resource.source
    end

    template "#{config_fullpath}" do
        source      'module.conf.erb'
        cookbook    'ganglia'
        owner       node[:ganglia][:user]
        group       node[:ganglia][:group]
        variables   ({
            :module => {
                :name => node_resource.name,
                :path => plugin_fullpath
            },
            :metrics => node_resource.metrics,
            :time => {
                :collect   => node_resource.collect_time,
                :threshold => node_resource.threshold_time
            },
            :use_regex => node_resource.use_regex
        })

        notifies    :restart,   resources(:service => "ganglia_generator"), :delayed
    end
end

