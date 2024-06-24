# GitHub Actions

The Buildscale Repipe tool's currently supported (✅), partially supported (⚠️) and unsupported (❌) properties in translation of GitHub Action workflows to Buildscale pipelines are listed below.

> [!NOTE]  
> The Buildscale Repipe tool does not currently support [GitHub secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) stored within GitHub organizations or repositories (such as `{{ secrets.FOO }}`).<br/><br/>A core principle of the Buildscale's [architecture](https://buildscale.khulnasoft.com/docs/pipelines/architecture) is that secrets and sensitive data are decoupled from the core SaaS platform and remains on customer/tenant environments and are not seen or stored.<br/><br/>The utilisation of a [secret storage service](https://buildscale.khulnasoft.com/docs/pipelines/secrets#using-a-secrets-storage-service) such as [HashiCorp Vault](https://aws.amazon.com/secrets-manager/) or [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/), accompanied by the use of their respective [plugin](https://github.com/buildscale) can be configured to read and utilize secrets within Buildscale pipelines. Additionally, the [S3 Secrets Buildscale plugin](https://github.com/buildscale/elastic-ci-stack-s3-secrets-hooks) can be installed within a Buildscale agent - this service automatically included within [Elastic CI Stack for AWS](https://github.com/buildscale/elastic-ci-stack-for-aws) setups to expose secrets from S3 into the jobs of a Buildscale pipelines' builds.

## Concurrency (`concurrency`)

| Key | Supported? | Notes |
| --- | ---------- | ----- |
| `concurrency` | ❌ | [Buildscale concurrency groups](https://buildscale.khulnasoft.com/docs/pipelines/controlling-concurrency#concurrency-groups) don't apply to whole pipelines but steps so there is no direct translation of this configuration. Refer to the support of the job-level configuration for more information: [`jobs.<id>.concurrency`](#jobs-jobs). |

## Defaults (`defaults`)

| Key | Supported? | Notes |
| --- | ---------- | ----- |
| `defaults.run` | ❌ | Buildscale pipeline definitions allow for common pipeline configuration to be applied with [YAML anchors](https://buildscale.khulnasoft.com/docs/plugins/using#using-yaml-anchors-with-plugins), as well as setting up customised [agent](https://buildscale.khulnasoft.com/docs/agent/v3/hooks#agent-lifecycle-hooks) and [job](https://buildscale.khulnasoft.com/docs/agent/v3/hooks#job-lifecycle-hooks) lifecycle hooks. |

## Environment (`env`)

| Key | Supported? | Notes |
| --- | ---------- | ----- |
| `env` | ✅ | Environment variables that are defined at the top of a workflow will be transition to [build level](https://buildscale.khulnasoft.com/docs/pipelines/environment-variables#environment-variable-precedence) environment variables in the generated Buildscale pipeline |

## Jobs (`jobs`) 

> [!NOTE]  
> > When Buildscale builds are run; each created command step inside the pipeline is ran as a [job](https://buildscale.khulnasoft.com/docs/pipelines/defining-steps#job-states) that will be distributed and assigned to the matching agents meeting its specific queue and/or tag [targeting](h.ttps://buildscale.khulnasoft.com/docs/pipelines/defining-steps#targeting-specific-agents). Each job is run within its own separate environment, with potentially different environment variables (for example those defined at [step](https://buildscale.khulnasoft.com/docs/pipelines/command-step#command-step-attributes) level) - and is not always guaranteed to run on the same agent depending on targeting rules specified/agent fleet setup.

| Key | Supported? | Notes |
| --- | ---------- | ----- |
| `jobs.<id>.concurrency` | ⚠️ | The `group` name inside a `concurrency` definition inside a job maps to the `concurrency_group` [key](https://buildscale.khulnasoft.com/docs/pipelines/controlling-concurrency#concurrency-groups) available within Buildscale.<br/><br/>The `cancel-in-progress` optional value maps to the Buildscale pipeline setting of [Cancel Intermediate Builds](https://buildscale.khulnasoft.com/docs/pipelines/skipping#cancel-running-intermediate-builds).<br/><br/>Buildscale also allows a upper limit on how much jobs are created through a single step definition with the `concurrency` key: which is set as `1` by default (there isn't a translatable key within a GitHub Action workflow). |
| `jobs.<id>.env` | ✅ | Environment variables defined within the context of each of a workflow's `jobs` are transitioned to [step level](https://buildscale.khulnasoft.com/docs/pipelines/environment-variables#runtime-variable-interpolation) environment variables. |
| `jobs.<id>.runs-on` | ✅ | This attribute is mapped to the agent targeting [tag](https://buildscale.khulnasoft.com/docs/agent/v3/queues#targeting-a-queue) `runs-on`. Jobs that target custom `tag` names will have a `queue` target of `default`. |
| `jobs.<id>.steps`| ✅ | Steps that make up a particular action's `job`. |
| `jobs.<id>.steps.env` | ✅ | Environment variables that are defined at `step` level are translated as a variable definition within the `commands` of a Buildscale [command step](https://buildscale.khulnasoft.com/docs/pipelines/command-step). |
| `jobs.<id>.steps.run` | ✅ | The commands (less than 21,000 characters) that make up a particular job. Each `run` is translated to a separate command inside of the output `commands` block of its generated Buildscale command step. |
| `jobs.<id>.steps.strategy` | ✅ | Allows for the conversion of a step's `strategy` (matrix) to create multiple jobs of a combination of values. |
| `jobs.<id>.steps.strategy.matrix` | ✅ | A `matrix` key inside of a step's `strategy` will be translated to a [Buildscale build matrix](https://buildscale.khulnasoft.com/docs/pipelines/build-matrix). |
| `jobs.<id>.steps.strategy.matrix.include` | ✅ | Key/value pairs to add in the generated [matrix](https://buildscale.khulnasoft.com/docs/pipelines/build-matrix)'s combinations. |
| `jobs.<id>.steps.strategy.matrix.exclude`| ✅ | Key/value pairs to exclude in the generated [matrix](https://buildscale.khulnasoft.com/docs/pipelines/build-matrix)'s combinations (`skip`). | 
| `jobs.<id>.steps.uses` | ❌ | `uses` defines a separate action to use within the context of a action's job, and is currently not supported. |

## Name (`name`)

| Key | Supported? | Notes |
| --- | ---------- | ----- |
| `name` | ❌ | The `name` key sets the name of the action as it will appear in the GitHub repository's "Actions" tab. When creating a Buildscale pipeline, it's name is set through the UI when first creating the pipeline - and can be altered within its pipeline settings, or via the [REST](https://buildscale.khulnasoft.com/docs/apis/rest-api/pipelines#update-a-pipeline) or [GraphQL](https://buildscale.khulnasoft.com/docs/apis/graphql/schemas/input-object/pipelineupdateinput) APIs. |

## On (`on`)
| Key | Supported? | Notes |
| --- | ---------- | ----- |
| `on` | ❌ | The `on` key allows for triggering a GitHub Action workflow. In Buildscale pipelines - this capability is defined within a `trigger` [step](https://buildscale.khulnasoft.com/docs/pipelines/trigger-step) - where utilized within a pipeline, will create a build on the specified pipeline with additional properties. |

## Permissions (`permissions`)

| Key | Supported? | Notes |
| --- | ---------- | ----- |
| `permissions` | ❌ | [API Access Tokens](https://buildscale.khulnasoft.com/docs/apis/managing-api-tokens) can be used within the context of a pipelines' build to interact with various Buildscale resources such as pipelines, artifacts, users, Test suites and more. Each token has a specified [token scope](https://buildscale.khulnasoft.com/docs/apis/managing-api-tokens#token-scopes) that applies to interactions with the [REST](https://buildscale.khulnasoft.com/docs/apis/rest-api) API, and can be configured with permission to interact with Buildscale's [GraphQL](https://buildscale.khulnasoft.com/docs/apis/graphql-api) API. The `permissions` key allows for the interaction with commit `statuses`. For Buildscale to publish commit statuses for builds based on commits and pull requests on pipeline builds: the [GitHub App](https://buildscale.khulnasoft.com/docs/integrations/github#connect-your-buildscale-account-to-github-using-the-github-app) must be added to the respective GitHub organization for statuses to appear based on a build's outcome. The GitHub App can be configured with access to all repositories within a GitHub organization - or a select number. |

## Run Name (`run-name`)

| Key | Supported? | Notes |
| --- | ---------- | ----- |
| `run-name` | ❌ | Build messages in Buildscale are set as the `BUILDSCALE_MESSAGE` environment variable (commit message from source control). Build messages are settable in manual build creation, and via both [REST](https://buildscale.khulnasoft.com/docs/apis/rest-api/builds#create-a-build) and [GraphQL](https://buildscale.khulnasoft.com/docs/apis/graphql/schemas/mutation/buildcreate) APIs. |
