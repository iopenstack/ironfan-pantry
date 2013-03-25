include_recipe 'ark'

ark(:jzmq) do
  url       node[:jzmq][:release_url]
  version   node[:jzmq][:version]
end
