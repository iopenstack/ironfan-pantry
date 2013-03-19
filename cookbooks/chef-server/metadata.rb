maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures Chef Server"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))
recipe            "ironfan-chef-server", "Compacts the Chef Server CouchDB."
recipe            "ironfan-chef-server::rubygems-install", "Set up rubygem installed chef server."
recipe            "ironfan-chef-server::apache-proxy", "Configures Apache2 proxy for API and WebUI"
recipe            "ironfan-chef-server::nginx-proxy", "Configures NGINX proxy for API and WebUI"

%w{ ubuntu debian redhat centos fedora freebsd openbsd }.each do |os|
  supports os
end

%w{ runit bluepill daemontools couchdb apache2 nginx openssl zlib xml java gecode }.each do |cb|
  depends cb
end
