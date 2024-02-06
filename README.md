[![Release](https://github.com/octue/get-deployment-info/actions/workflows/release.yml/badge.svg)](https://github.com/octue/get-deployment-info/actions/workflows/release.yml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/ambv/black)

# Get deployment info

A GitHub action that gets the information needed to build and deploy an Octue service to the cloud from a
main/production branch or a non-main/development branch. The required information is extracted and/or generated from:

- The action inputs
- `git`
- `pyproject.toml` or `setup.py`

## Usage

Add the action as a step in your workflow:

```yaml
steps:
  - name: Checkout
    uses: actions/checkout@v3

  - name: Install poetry
    uses: snok/install-poetry@v1.3.3

  - name: Get deployment info
    id: get-deployment-info
    uses: octue/get-deployment-info@0.3.1
    with:
      gcp_project_name: test-project
      gcp_project_number: 1234
      gcp_region: europe-west1
      gcp_resource_affix: test
      gcp_service_name: my-test-service
      gcp_environment: main
```

Outputs can be accessed in the usual way. For example, to print all the outputs:

```yaml
- name: Print outputs
  run: |
    echo ${{ steps.get-deployment-info.outputs.branch_tag_kebab }}
    echo ${{ steps.get-deployment-info.outputs.branch_tag_screaming }}
    echo ${{ steps.get-deployment-info.outputs.image_latest_artifact }}
    echo ${{ steps.get-deployment-info.outputs.image_latest_tag }}
    echo ${{ steps.get-deployment-info.outputs.image_version_artifact }}
    echo ${{ steps.get-deployment-info.outputs.image_version_tag }}
    echo ${{ steps.get-deployment-info.outputs.short_sha }}
    echo ${{ steps.get-deployment-info.outputs.version_slug }}
    echo ${{ steps.get-deployment-info.outputs.revision_tag }}
    echo ${{ steps.get-deployment-info.outputs.revision_tag_slug }}
    echo ${{ steps.get-deployment-info.outputs.gcp_environment }}
    echo ${{ steps.get-deployment-info.outputs.gcp_project_name }}
    echo ${{ steps.get-deployment-info.outputs.gcp_project_number }}
    echo ${{ steps.get-deployment-info.outputs.gcp_region }}
    echo ${{ steps.get-deployment-info.outputs.gcp_resource_affix }}
    echo ${{ steps.get-deployment-info.outputs.gcp_service_name }}
    echo ${{ steps.get-deployment-info.outputs.version }}
```

Note: there's no need to print the outputs for debugging in practice - the action prints them to `stdout` for this very
purpose.

## Main vs non-main branch deployments

Some of the outputs' values depend on whether the action is run on the `main` branch or a non-`main` branch.

### Main branch deployments

- `revision_tag` is `<version>`
- `image_version_tag` is `main-<version>`
- `image_latest_tag` is `main-latest`

### Non-main branch deployments

The truncated branch name (first 12 characters) is used to ensure service names are short enough to be accepted by e.g.
Cloud Run without having to restrict the length of branch names.

- `revision_tag` is `<truncated branch_tag_kebab>`
- `image_version_tag` is `<truncated branch_tag_kebab>`
- `image_latest_tag` is `<truncated branch_tag_kebab>-latest`
