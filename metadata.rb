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

recipe "apps-couchbase", "Configures Couchbase for apps."
recipe "apps-couchbase::buckets", "Setup buckets from the apps data bag."
recipe "apps-couchbase::yaml", "Generates a couchbase.yml file compatible with the couchbase-model gem."
