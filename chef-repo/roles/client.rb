name "client"
description "Tests for Couchbase Client"

run_list(
  "recipe[users::sysadmins]",
  "recipe[apps]",
  "recipe[apps-couchbase::yaml]",
)

default_attributes({
  "framework_environment" => "production",
  "minitest" => {
    "tests" => "apps-couchbase/yaml_test.rb",
  },
})
