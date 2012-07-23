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
  "minitest" => {
    "tests" => "apps-couchbase/buckets_test.rb",
  },
})
