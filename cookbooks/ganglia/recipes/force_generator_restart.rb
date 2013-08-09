script "force_ganglia_generator_restart" do
  interpreter "bash"
  code <<-EOF
    sv restart ganglia_generator
  EOF
  action :run
end