load /usr/lib/bats-support/load
load /usr/lib/bats-assert/load

@test "PlatformCLI version" {
  run platform version
  assert_output "PlatformCLI v2.4.1.0"
}

@test "Stackctl version" {
  run stackctl version
  assert_output "Stackctl v1.2.0.0"
}

@test "Logging ENV" {
  assert_equal "$LOG_COLOR" always
  assert_equal "$LOG_DESTINATION" stderr
}

@test "Stackctl ENV" {
  assert_equal "$STACKCTL_DIRECTORY" .platform/specs
}

@test "PlatformCLI ENV" {
  assert_equal "$PLATFORM_APP" ""
  assert_equal "$PLATFORM_ENVIRONMENT" ""
  assert_equal "$PLATFORM_RESOURCE" ""
  assert_equal "$PLATFORM_NO_VALIDATE" ""
}

@test "tag" {
  assert [[ -n "$TAG" ]]

  case "$GH_EVENT_NAME" in
    pull_request)
      assert_equal "$TAG" "$GH_PR_HEAD_SHA"
      ;;
    push)
      assert_equal "$TAG" "$GH_PUSH_SHA"
      ;;
    *)
      assert_equal "$TAG" "$GH_SHA"
      ;;
  esac
}
