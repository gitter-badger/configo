#!/usr/bin/env bats

load test_helper

@test "templates: functions" {
  run_container <<EOC
  export SOME_PROPERTY=123
  export TEST_PROPERTY="CONFIGO:some property value is: {{or .NON_EXISTING_PROPERTY .ANOTHER_NON_EXISTING_PROPERTY .SOME_PROPERTY `default`}}"
  configo printenv TEST_PROPERTY
EOC
  
  assert_success "some property value is: 123"
}