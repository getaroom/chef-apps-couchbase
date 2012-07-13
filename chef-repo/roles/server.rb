name "server"
description "Tests for Couchbase Server"

run_list(
  "recipe[couchbase::server]",
  "recipe[couchbase::test_buckets]",
  "recipe[apps-couchbase]",
)

default_attributes({
  "couchbase" => {
    "server" => {
      "password" => "password",
    },
  },
})
