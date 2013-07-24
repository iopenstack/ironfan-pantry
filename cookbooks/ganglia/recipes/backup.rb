
include_recipe "github"
include_recipe "cron"



git "/mnt/hecube3" do
    repo        "git@github.com:Technicolor-Portico/hecube.git"
    revision    "master"
    user        user
    group       group
    action      :sync
end



config = {
    :region => node[:ganglia][:grid],
    :path => node[:ganglia][:home_dir]

}

template "/mnt/hecube3/ganglia/servername.txt" do
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
  command "/mnt/hecube3/ganglia/ganglia_backup.sh -d #{node[:ganglia][:home_dir]}  -p #{node[:ganglia][:grid].split("_").first} -c #{node[:ganglia][:grid].split("_").last}  >> /var/log/ganglia_backup.log 2>&1"
  action :create
end




