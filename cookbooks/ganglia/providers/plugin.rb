action :deploy do
  run_deploy
end

protected

def run_deploy
    #
    # parameters :
    # name          (mandatory) plugin name (e.g. "storm") --> will create ganglia plugin named: mod<name>.so
    #                                                                                and config: mod<name>.conf
    # source_lib    (mandatory) 
    # source_conf   (mandatory) 
    #

    node_resource = @new_resource

    plugin_dir  = node[:ganglia][:plugin_dir]
    plugin_file = "mod#{node_resource.name}.so"
    config_file = "mod#{node_resource.name}.conf"
    plugin_fullpath = "#{plugin_dir}/#{plugin_file}"
    config_fullpath = "#{plugin_dir}/#{config_file}"
    
    if ::File.directory?(plugin_dir)
        link(plugin_fullpath).to node_resource.source_lib
        link(config_fullpath).to node_resource.source_conf
    end

    runit_service "ganglia_generator" do
        action      :restart
    end
end

