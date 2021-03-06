name             "storm"
maintainer       "Technicolor, Portico"
maintainer_email "dev@portico.io"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Installs Twitter's Storm distributed computation system"

depends          "java"
depends          "runit"
depends          "zeromq"
depends          "jzmq"
depends          "silverware"
depends          "install_from"
depends          "github"
depends          "ganglia"

recipe           "storm::default",                  "Base configuration for storm"
recipe           "storm::ui",                       "Storm web UI"
recipe           "storm::nimbus",                   "Storm NIMBUS service"
recipe           "storm::supervisor",               "Storm SUPERVISOR service"
recipe           "storm::install_from_release",     "Install from release version"
recipe           "storm::statistics",               "Install Ganglia statistics plugin"

%w[ ubuntu ].each do |os|
  supports os
end

