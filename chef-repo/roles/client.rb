name "client"
description "Tests for Couchbase Client"

run_list(
  "recipe[users::sysadmins]",
  "recipe[apps]",
  "recipe[apps-couchbase]",
)

default_attributes({
  "minitest" => {
    "tests" => "apps-couchbase/yaml_test.rb",
  },
})
