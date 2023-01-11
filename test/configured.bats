load /usr/lib/bats-support/load
load /usr/lib/bats-assert/load

@test "PlatformCLI version" {
  run platform version
  assert_output "PlatformCLI v2.1.0.0"
}

@test "Stackctl version" {
  run stackctl version
  assert_output "Stackctl v1.1.4.0"
}

@test "PlatformCLI ENV" {
  assert_equal "$PLATFORM_APP" "my-app"
  assert_equal "$PLATFORM_ENVIRONMENT" "dev"
  assert_equal "$PLATFORM_RESOURCE" "my-resource"
  assert_equal "$PLATFORM_NO_VALIDATE" "1"
}
