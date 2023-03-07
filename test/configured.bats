load /usr/lib/bats-support/load
load /usr/lib/bats-assert/load

@test "PlatformCLI version" {
  run platform version
  assert_output "2.1.0.0"
}

# TODO https://github.com/freckle/stackctl/pull/34
# @test "Stackctl version" {
#   run stackctl version
#   assert_output "Stackctl v1.1.4.0"
# }

@test "Stackctl ENV" {
  assert_equal "$STACKCTL_DIRECTORY" my-app/.platform/specs
}

@test "PlatformCLI ENV" {
  assert_equal "$PLATFORM_APP_DIRECTORY" "my-app"
  assert_equal "$PLATFORM_ENVIRONMENT" "dev"
  assert_equal "$PLATFORM_RESOURCE" "my-resource"
  assert_equal "$PLATFORM_NO_VALIDATE" "1"
}

@test "Slack notification ENV" {
  assert_equal "$SLACK_TITLE" "Deploy my-app/my-resource to dev"
}
