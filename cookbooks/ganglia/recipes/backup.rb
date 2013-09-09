include_recipe "cron"
package "s3cmd"

git "/mnt/hecube" do
  repo        "git@github.com:Technicolor-Portico/hecube.git"
  revision    "master"
  user        user
  group       group
  action      :sync
end

aws_dbi = data_bag_item('global_access_settings', 'aws')
config = {
  :access_key => aws_dbi["access_key"],
  :secret_key => aws_dbi["secret_key"],
}

template "/root/.s3cfg" do
    source      's3cfg.erb'
    backup      false
    owner       node[:ganglia][:user]
    group       node[:ganglia][:group]
    mode        '0644'
    variables(config)
end

cron "ganglia_backup" do
  minute 0
  user user
  command "/mnt/hecube/ganglia/ganglia_backup.sh -d #{node[:ganglia][:home_dir]}  -p #{node[:ganglia][:grid].split("_").first} -c #{node[:ganglia][:grid].split("_").last}  >> /var/log/ganglia_backup.log 2>&1"
  action :create
end
