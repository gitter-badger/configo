#!/usr/bin/env bats

load ../test_helper

@test "sources: HTTP works" {
  CONTAINER_ID=$(docker run -d --label configo="true" nginx:1.9.9)
  docker exec -i $CONTAINER_ID bash <<EOC
/bin/cat <<EOF >/usr/share/nginx/html/test.json
{
  "some": {
    "nested": {
      "structure": true
    }
  }
}
EOF
EOC
  
  run_container_with_parameters "--link $CONTAINER_ID:nginx" <<EOC
  export CONFIGO_SOURCE_0='{"type": "http", "format": "json", "url": "http://nginx/test.json"}'
  configo printenv SOME_NESTED_STRUCTURE
EOC

  assert_success "true"
}