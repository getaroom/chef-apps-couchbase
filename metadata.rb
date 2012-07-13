name             "apps-couchbase"
maintainer       "getaroom"
maintainer_email "devteam@roomvaluesteam.com"
license          "MIT"
description      "Configures Couchbase for Apps"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
version          "1.0.0"

depends "couchbase"

supports "debian"
supports "ubuntu"

recipe "apps-couchbase", "Setup buckets from the apps data bag"
