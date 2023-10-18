LockManager() {
    set -x
    BRANCH=$(eval echo "${PARAM_BRANCH_PATTERN}")
    LOCK_BRANCH=$(eval echo "${PARAM_LOCK}")

    BRANCH_PROTECTION_CONFIG=$(gh api \
    "repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/branches/${BRANCH}/protection" \
    -X GET -H "Accept: application/vnd.github.v3+json")

    echo "Current branch configuration:"
    echo "${BRANCH_PROTECTION_CONFIG}" | jq

    # Use https://jqplay.org/ to help understand these filters
    # required_status_checks=$(echo ${BRANCH_PROTECTION_CONFIG} | jq '.required_status_checks | del(.url) | del(.contexts_url) | .checks = (.checks | map_values(if .app_id == null then {"context": .context, "app_id": -1} else . end))')
    required_status_checks=$(echo "${BRANCH_PROTECTION_CONFIG}" | jq '.required_status_checks | del(.url) | del(.contexts_url) | del(.checks)')

    enforce_admins=$(echo "${BRANCH_PROTECTION_CONFIG}" | jq -r '.enforce_admins.enabled')
    required_pull_request_reviews=$(echo "${BRANCH_PROTECTION_CONFIG}" | jq '.required_pull_request_reviews | del(.url)')
    restrictions=$(echo "${BRANCH_PROTECTION_CONFIG}" | jq --raw-output '.restrictions | del(.url) | del(.users_url) | del(.teams_url) | del(.apps_url) | .users=(.users | map(.login)) | .teams=(.teams | map(.slug)) | .apps=(.apps | map(.slug))')

    NEW_PAYLOAD=$(jq --null-input -r \
    --argjson required_status_checks "${required_status_checks}" \
    --argjson enforce_admins "${enforce_admins}" \
    --argjson required_pull_request_reviews "${required_pull_request_reviews}" \
    --argjson restrictions "${restrictions}" \
    --argjson lock_branch "${LOCK_BRANCH}" \
    '{
        "required_status_checks": $required_status_checks,
        "enforce_admins": $enforce_admins,
        "required_pull_request_reviews": $required_pull_request_reviews,
        "restrictions": $restrictions,
        "lock_branch": $lock_branch
    }'
    )

    echo "Sending the following JSON payload to GitHub:"
    echo "${NEW_PAYLOAD}" | jq
    echo
    echo "Output from API Call:"

    echo "${NEW_PAYLOAD}" | gh api \
            "repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/branches/${BRANCH}/protection" \
            -X PUT -H "Accept: application/vnd.github.v3+json" \
            --input -
}

VerifyEnvironentVariable(){
    if [[ -z "${!1}" ]]; then
        echo "Required environment variable \"${1}\" does not exist."
        exit 1
    fi
}

VerifyCommandExists(){
    if ! command -v "$1" &> /dev/null
    then
        echo "$1 could not be found"
        exit 1
    fi
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*"$ORB_TEST_ENV"}" == "$0" ]; then
    VerifyCommandExists "gh"
    VerifyCommandExists "jq"
    VerifyEnvironentVariable "GITHUB_TOKEN"
    LockManager
fi
