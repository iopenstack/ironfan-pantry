maintainer          "Portico"
maintainer_email    "dev@portico.io"
license             "Apache 2.0"
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version             IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description         "Ganglia: a distributed high-performance monitoring system"

depends  "java"
depends  "runit"
depends  "volumes"
depends  "silverware"
depends  "build-essential"
depends  "github"
depends  "cron"

