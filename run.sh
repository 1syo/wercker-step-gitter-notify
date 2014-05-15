if [ ! -n "$WERCKER_GITTER_NOTIFY_TOKEN" ]; then
  fail 'Please specify token property.'
fi

if [ "$WERCKER_GITTER_NOTIFY_ON" = "failed" ]; then
  info "Skipping..."
  return 0
fi

if [ "$WERCKER_RESULT" = "passed" ]; then
  status="passed"
else
  status="errored"
fi

if [ "$CI" = "true" ]; then
  step="build"
  id=$WERCKER_BUILD_ID
  wercker_url=$WERCKER_BUILD_URL
elif [ "$DEPLOY" = "true" ]; then
  step="deploy"
  id=$WERCKER_DEPLOY_ID
  wercker_url=$WERCKER_DEPLOY_URL
else
  step="build"
  id=$WERCKER_BUILD_ID
  wercker_url=$WERCKER_BUILD_URL
fi

github_url="https://$WERCKER_GIT_DOMAIN/$WERCKER_GIT_OWNER/$WERCKER_GIT_REPOSITORY/tree/$WERCKER_GIT_BRANCH"

info "step: $step"
info "id: $id"
info "wercker_url: $wercker_url"
info "github_url: $github_url"

result=`curl -s \
  --data-urlencode "message=Wercker [$WERCKER_GIT_OWNER/$WERCKER_GIT_REPOSITORY ($WERCKER_GIT_BRANCH)]($github_url) $step [$status]($wercker_url) ($id)" \
  "https://webhooks.gitter.im/e/$WERCKER_GITTER_NOTIFY_TOKEN" \
  --output "$WERCKER_STEP_TEMP/result.txt" \
  --write-out "%{http_code}"`

if [ "$result" = "200" ]; then
  success "Finished successfully!"
else
  echo -e "`cat $WERCKER_STEP_TEMP/result.txt`"
  fail "Finished Unsuccessfully."
fi
