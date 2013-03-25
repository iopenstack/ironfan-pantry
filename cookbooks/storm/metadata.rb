name             "storm"
maintainer       "Technicolor, Portico"
maintainer_email "bart.vercammen@portico.io"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

version          "0.0.1"
description      "Installs Twitter's Storm distributed computation system"

depends          "java"
depends          "runit"
depends          "zeromq"
depends          "jzmq"
depends          "silverware"
depends          "install_from"

recipe           "storm::default",                  "Base configuration for storm"
recipe           "storm::ui",                       "Storm web UI"
recipe           "storm::nimbus",                   "Storm NIMBUS service"
recipe           "storm::supervisor",               "Storm SUPERVISOR service"
recipe           "storm::install_from_release",     "Install from release version"

%w[ debian ubuntu ].each do |os|
  supports os
end

