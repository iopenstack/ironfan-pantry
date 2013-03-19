maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Installs/Configures hive"

depends          "ironfan-java"
depends          "ironfan-hadoop_cluster"

recipe           "ironfan-hive::default",                      "Base configuration for hive"

%w[ debian ubuntu ].each do |os|
  supports os
end
