#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# shellcheck disable=SC2086
luacheck --formatter plain ${INPUT_LUACHECK_FLAGS} . \
  | reviewdog -efm="%f:%l:%c: %m" \
      -name="luacheck" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      # shellcheck disable=SC2086
      ${INPUT_REVIEWDOG_FLAGS}
exit_code=$?

exit $exit_code
