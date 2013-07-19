include_recipe "github"
include_recipe "cron"



git "/mnt/hecube" do
    repo        "git@github.com:Technicolor-Portico/hecube.git"
    revision    "master"
    user        user
    group       group
    action      :sync
end



config = {
    :region => node[:ganglia][:grid]
}

template "/mnt/hecube/ganglia/servername.txt" do
    source      'hecube-servername.erb'
    backup      false
    owner       node[:ganglia][:user]
    group       node[:ganglia][:group]
    mode        '0644'
    variables(config)
end


cron "ganglia_backup" do
  minute 0
  user user
  command "/mnt/hecube/ganglia/cron.sh >> /var/log/ganglia_backup.log 2>&1"
  action :create
end




