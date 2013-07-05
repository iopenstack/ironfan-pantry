include_recipe "github"

deploy "/mnt/hecubetest" do
    repo "git@github.com:Technicolor-Portico/hecube.git"
    revision "master"
    symlinks.clear
    symlink_before_migrate.clear
    migrate false
    user user
    group group
    action :deploy
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
