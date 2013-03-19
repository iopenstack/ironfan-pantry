maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs thrift from source"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

recipe "ironfan-thrift", "Installs thrift from source"

supports "ubuntu"

depends 'ironfan-build-essential'
depends 'ironfan-boost'
depends 'ironfan-python'
depends 'ironfan-install_from'
