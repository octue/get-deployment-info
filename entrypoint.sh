#!/bin/sh -l
ARTIFACT_REGISTRY_REPOSITORY=octue-twined-services

# Get inputs
GCP_PROJECT_ID=$1
GCP_PROJECT_NUMBER=$2
GCP_REGION=$3
GCP_RESOURCE_AFFIX=$4
GCP_SERVICE_NAME=$5

# Get package version.
if [ -f "pyproject.toml" ]; then VERSION=$(poetry version -s); \
elif [ -f "setup.py" ]; then VERSION=$(python setup.py --version);
fi

echo "version=$VERSION" >> $GITHUB_OUTPUT

VERSION_SLUG=$(echo $VERSION | tr . -)
echo "version_slug=$VERSION_SLUG" >> $GITHUB_OUTPUT

# Get GCP variables.
echo "gcp_project_name=$GCP_PROJECT_ID" >> $GITHUB_OUTPUT
echo "gcp_project_number=$GCP_PROJECT_NUMBER" >> $GITHUB_OUTPUT
echo "gcp_region=$GCP_REGION" >> $GITHUB_OUTPUT
echo "gcp_resource_affix=$GCP_RESOURCE_AFFIX" >> $GITHUB_OUTPUT
echo "gcp_service_name=$GCP_SERVICE_NAME" >> $GITHUB_OUTPUT

# Get slugified branch name, resource names, and docker image tags.
SHORT_SHA="$(git config --global --add safe.directory /github/workspace && git rev-parse --short HEAD)"
echo "short_sha=$SHORT_SHA" >> $GITHUB_OUTPUT

BRANCH_TAG_KEBAB=$(echo ${GITHUB_REF#refs/heads/} | iconv -c -t ascii//TRANSLIT | sed -E 's/[~^]+//g' | sed -E 's/[^a-zA-Z0-9]+/-/g' | sed -E 's/^-+|-+$//g' | tr A-Z a-z)
echo "branch_tag_kebab=$BRANCH_TAG_KEBAB" >> $GITHUB_OUTPUT

BRANCH_TAG_SCREAMING=$(echo $BRANCH_TAG_KEBAB | tr '[:lower:]' '[:upper:]'  | tr - _)
echo "branch_tag_screaming=$BRANCH_TAG_SCREAMING" >> $GITHUB_OUTPUT

if [ "$BRANCH_TAG_KEBAB" = "main" ]; then
  REVISION_TAG=$VERSION
  IMAGE_VERSION_TAG=$REVISION_TAG
  IMAGE_LATEST_TAG="latest"
  GCP_ENVIRONMENT_KEBAB="production"
  GCP_ENVIRONMENT_SCREAMING="PRODUCTION"
else
  REVISION_TAG=$(python -c "print('$BRANCH_TAG_KEBAB'[:16].strip('-_'))")
  IMAGE_VERSION_TAG="$REVISION_TAG"
  IMAGE_LATEST_TAG="$REVISION_TAG-latest"
  GCP_ENVIRONMENT_KEBAB="staging"
  GCP_ENVIRONMENT_SCREAMING="STAGING"
fi

echo "revision_tag=$REVISION_TAG" >> $GITHUB_OUTPUT
echo "image_version_tag=$IMAGE_VERSION_TAG" >> $GITHUB_OUTPUT
echo "image_latest_tag=$IMAGE_LATEST_TAG" >> $GITHUB_OUTPUT
echo "gcp_environment_kebab=$GCP_ENVIRONMENT_KEBAB" >> $GITHUB_OUTPUT
echo "gcp_environment_screaming=$GCP_ENVIRONMENT_SCREAMING" >> $GITHUB_OUTPUT

REVISION_TAG_SLUG=$(echo $REVISION_TAG | tr . -)
echo "revision_tag_slug=$REVISION_TAG_SLUG" >> $GITHUB_OUTPUT

# Set image artifact addresses.
IMAGE_VERSION_ARTIFACT="$GCP_REGION-docker.pkg.dev/$GCP_PROJECT_ID/$ARTIFACT_REGISTRY_REPOSITORY/$GCP_RESOURCE_AFFIX/$GCP_SERVICE_NAME:$IMAGE_VERSION_TAG"
echo "image_version_artifact=$IMAGE_VERSION_ARTIFACT" >> $GITHUB_OUTPUT

IMAGE_LATEST_ARTIFACT="$GCP_REGION-docker.pkg.dev/$GCP_PROJECT_ID/$ARTIFACT_REGISTRY_REPOSITORY/$GCP_RESOURCE_AFFIX/$GCP_SERVICE_NAME:$IMAGE_LATEST_TAG"
echo "image_latest_artifact=$IMAGE_LATEST_ARTIFACT" >> $GITHUB_OUTPUT

IMAGE_DEFAULT_ARTIFACT="$GCP_REGION-docker.pkg.dev/$GCP_PROJECT_ID/$ARTIFACT_REGISTRY_REPOSITORY/$GCP_RESOURCE_AFFIX/$GCP_SERVICE_NAME:default"
echo "image_default_artifact=$IMAGE_DEFAULT_ARTIFACT" >> $GITHUB_OUTPUT


# Echo the outputs to stdout to aid debugging.
echo ""
echo "OUTPUTS"
echo "======="
echo "- branch_tag_kebab: $BRANCH_TAG_KEBAB"
echo "- branch_tag_screaming: $BRANCH_TAG_SCREAMING"
echo "- image_latest_artifact: $IMAGE_LATEST_ARTIFACT"
echo "- image_latest_tag: $IMAGE_LATEST_TAG"
echo "- image_version_artifact: $IMAGE_VERSION_ARTIFACT"
echo "- image_version_tag: $IMAGE_VERSION_TAG"
echo "- image_default_artifact: $IMAGE_DEFAULT_ARTIFACT"
echo "- short_sha: $SHORT_SHA"
echo "- version: $VERSION"
echo "- version_slug: $VERSION_SLUG"
echo "- revision_tag: $REVISION_TAG"
echo "- revision_tag_slug: $REVISION_TAG_SLUG"
echo "- gcp_project_name: $GCP_PROJECT_ID"
echo "- gcp_project_number: $GCP_PROJECT_NUMBER"
echo "- gcp_region: $GCP_REGION"
echo "- gcp_resource_affix: $GCP_RESOURCE_AFFIX"
echo "- gcp_service_name: $GCP_SERVICE_NAME"
echo "- gcp_environment_kebab: $GCP_ENVIRONMENT_KEBAB"
echo "- gcp_environment_screaming: $GCP_ENVIRONMENT_SCREAMING"
