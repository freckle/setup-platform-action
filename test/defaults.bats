load /usr/lib/bats-support/load
load /usr/lib/bats-assert/load

@test "PlatformCLI version" {
  run platform version
  assert_output "PlatformCLI v3.2.0.1"
}

@test "Stackctl version" {
  run stackctl version
  assert_output "Stackctl v1.5.0.1"
}

@test "Logging ENV" {
  assert_equal "$LOG_COLOR" always
  assert_equal "$LOG_DESTINATION" stderr
}

@test "Stackctl ENV" {
  assert_equal "$STACKCTL_DIRECTORY" ./.platform/specs
}

@test "PlatformCLI ENV" {
  assert_equal "$PLATFORM_APP_DIRECTORY" ""
  assert_equal "$PLATFORM_ENVIRONMENT" ""
  assert_equal "$PLATFORM_RESOURCE" ""
  assert_equal "$PLATFORM_NO_VALIDATE" ""
}

@test "Slack notification ENV" {
  assert_equal "$SLACK_ICON" "https://github.com/freckle-automation.png?size=48"
  assert_equal "$SLACK_USERNAME" "GitHub Actions"
  assert_equal "$SLACK_TITLE" "Deploy"
  assert_equal "$SLACK_FOOTER" "$TAG"
  assert_equal "$MSG_MINIMAL" "actions url,commit"
}

@test "tag" {
  assert test -n "$TAG"

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
