maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Sets up sources for ubuntu"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))
depends           "ironfan-apt"
supports          "ubuntu"
recipe            "ironfan-ubuntu", "Sets up sources for the node's ubuntu release"
