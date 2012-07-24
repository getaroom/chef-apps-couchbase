name "server"
description "Tests for Couchbase Server"

run_list(
  "recipe[couchbase::server]",
  "recipe[apps-couchbase]",
)

default_attributes({
  "couchbase" => {
    "server" => {
      "password" => "password",
    },
  },
  "framework_environment" => "production",
  "minitest" => {
    "tests" => "apps-couchbase/buckets_test.rb",
  },
})
