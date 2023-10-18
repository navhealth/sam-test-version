# CareJourney Version Control Orb
<!---
[![CircleCI Build Status](https://circleci.com/gh/navhealth/sam-test-version.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/navhealth/sam-test-version) [![CircleCI Orb Version](https://badges.circleci.com/orbs/carejourney/version.svg)](https://circleci.com/orbs/registry/orb/carejourney/versionv2) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/navhealth/cj-circleci-orb-version/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

--->

This Orb handles the version bumping for NodeJS projects within CareJourney's standard build environment.

More languages will be added later.

## Usage

See `src/examples/` for examples of how to use this orb.


### How to Publish
* Create and push a branch with your new features.
* When ready to publish a new production version, create a Pull Request from _feature branch_ to `master`.
* The title of the pull request must contain a special semver tag: `[semver:<segment>]` where `<segment>` is replaced by one of the following values.

| Increment | Description|
| ----------| -----------|
| major     | Issue a 1.0.0 incremented release|
| minor     | Issue a x.1.0 incremented release|
| patch     | Issue a x.x.1 incremented release|
| skip      | Do not issue a release|

Example: `[semver:major]`

* Squash and merge. Ensure the semver tag is preserved and entered as a part of the commit message.
* On merge, after manual approval, the orb will automatically be published to the Orb Registry.


For further questions/comments about this or other orbs, visit the Orb Category of [CircleCI Discuss](https://discuss.circleci.com/c/orbs).

