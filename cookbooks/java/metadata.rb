maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs Java runtime."
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

recipe "ironfan-java", "Installs Java runtime"
recipe "ironfan-java::openjdk", "Installs the OpenJDK flavor of Java"
recipe "ironfan-java::oracle", "Installs the Oracle flavor of Java"
recipe "ironfan-java::oracle_i386", "Installs the 32-bit jvm without setting it as the default"

depends "ironfan-apt"

%w{ debian ubuntu centos redhat scientific fedora amazon arch freebsd }.each do |os|
  supports os
end
