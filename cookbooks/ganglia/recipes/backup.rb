include_recipe "github"



git "/mnt/hecubetest2" do
    repo        "git@github.com:Technicolor-Portico/hecube.git"
    revision    "master"
    user        user
    group       group
    action      :sync
end



config = {
    :region => node[:ganglia][:grid]
}

template "/mnt/hecubetest/servername.txt" do
    source      'hecube-servername.erb'
    backup      false
    owner       node[:ganglia][:user]
    group       node[:ganglia][:group]
    mode        '0644'
    variables(config)
end
