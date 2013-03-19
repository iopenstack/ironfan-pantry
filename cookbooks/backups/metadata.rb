maintainer       "Brandon Bell - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Backups -- coordinates backups of your stuff"

depends		 "ironfan-hbase"
depends		 "ironfan-mongodb"
depends		 "ironfan-hadoop_cluster"

recipe           "ironfan-backups::default",       "Default Recipe"
recipe           "ironfan-backups::namenode",      "Namenode Backup Recipe"
recipe           "ironfan-backups::s3cfg",         "S3 Configuration Recipe"
recipe           "ironfan-backups::hbase",         "HBase Backup Recipe"
recipe           "ironfan-backups::zookeeper",     "Zookeeper Backup Recipe"
recipe           "ironfan-backups::elasticsearch", "Elasticsearch Backup Recipe"
recipe           "ironfan-backups::mongodb",       "MongoDB backup Recipe"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "backups/location",
  :display_name          => "",
  :description           => "Directory in which to backup to",
  :default               => "/mnt/backups"

attribute "backups/namenode/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "hadoop"

attribute "backups/hbase/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "hbase"

attribute "backups/zookeeper/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "zookeeper"

attribute "backups/elasticsearch/cluster_name",
  :display_name          => "",
  :description           => "",
  :default               => "elasticsearch"

