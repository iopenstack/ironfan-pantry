name             "storm"
maintainer       "Technicolor, Portico"
maintainer_email "bart.vercammen@portico.io"
license          "Apache 2.0"

version          "0.0.1"
description      "jzmq"

depends          "ark"

recipe           "jzmq::install_from_release", "Installs JZMQ"

%w[ debian ubuntu ].each do |os|
  supports os
end
