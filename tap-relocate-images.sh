#!/bin/bash

# Grab a list of available version, note the versions returned is dependent on which account
# you are logged into to the below repo, vmware accounts can see rc's,beta's, etc.

# imgpkg tag list -i registry.tanzu.vmware.com/tanzu-application-platform/tap-packages | sort -V

# Choose the version we want

export TAP_VERSION="1.6.3"
export INSTALL_REGISTRY_HOSTNAME=us-east4-docker.pkg.dev
export INSTALL_REPO="tappackages"
export GOOGLE_PROJECTS=bfabian-gcp


# Now move from registry.tanzu.vmware.com to the repo of choice, this uses your local docker login creds to
# accomplish the move

imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${GOOGLE_PROJECTS}/${INSTALL_REPO}/tap-packages
wait

echo "========================================================================================================="
