# sudoblark.terraform.module.aws.api_gateway
Terraform module to create N number of API Gateways, usage plans and usage keys. - repo managed by sudoblark.terraform.github

## Developer documentation
The below documentation is intended to assist a developer with interacting with the Terraform module in order to add,
remove or update functionality.

### Pre-requisites
* terraform_docs

```sh
brew install terraform_docs
```

* tfenv
```sh
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
```

* Virtual environment with pre-commit installed

```sh
python3 -m venv venv
source venv/bin/activate
pip install pre-commit
```
### Pre-commit hooks
This repository utilises pre-commit in order to ensure a base level of quality on every commit. The hooks
may be installed as follows:

```sh
source venv/bin/activate
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

# Module documentation
The below documentation is intended to assist users in utilising the module, the main thing to note is the
[data structure](#data-structure) section which outlines the interface by which users are expected to interact with
the module itself, and the [examples](#examples) section which has examples of how to utilise the module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_api_key.api_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key) | resource |
| [aws_api_gateway_deployment.deployments](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_rest_api.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.stages](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_usage_plan.usage_plans](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_api_gateway_usage_plan_key.keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan_key) | resource |
| [aws_lambda_permission.allow_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Name of the application utilising resource. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Which environment this is being instantiated in. | `string` | n/a | yes |
| <a name="input_raw_api_gateway_rest_apis"></a> [raw\_api\_gateway\_rest\_apis](#input\_raw\_api\_gateway\_rest\_apis) | Data structure<br>---------------<br>A list of dictionaries, where each dictionary has the following attributes:<br><br>REQUIRED<br>---------<br>- suffix                : Suffix to use when creating the RESTAPI Gateway<br>- open\_api\_file\_path    : Path to OpenAPI definition file<br>- description           : A human-friendly description of the API<br><br><br>OPTIONAL<br>---------<br>- template\_input        : A dictionary of variable input for the OpenAPI definition file (leave blank if no template required)<br>- allowed\_lambdas       : A list of strings, where each string is the function\_name of a lambda to allow access to.<br>- quota\_limit           : Maximum number of requests that can be made in a given time period, defaults to 10.<br>- quota\_offset          : Number of requests subtracted from the given limit in the initial time period, defaults to 0.<br>- quota\_period          : Time period in which the limit applies. Valid values are "DAY", "WEEK" or "MONTH". Defaults to "DAY"<br>- burst\_limit           : The API request burst limit, the maximum rate limit over a time ranging from one to a few seconds, depending upon whether the underlying token bucket is at its full capacity. Defaults to 5.<br>- rate\_limit            : The API request steady-state rate limit, defaults to 10.<br>- api\_keys              : List of strings, where each string is name of an API key to create for the API, defaults to empty list. | <pre>list(<br>    object({<br>      suffix             = string,<br>      description        = string,<br>      open_api_file_path = string,<br>      template_input     = optional(map(string), {}),<br>      quota_limit        = optional(number, 10),<br>      quota_offset       = optional(number, 0),<br>      quota_period       = optional(string, "DAY"),<br>      burst_limit        = optional(number, 5),<br>      rate_limit         = optional(number, 10)<br>      allowed_lambdas    = optional(list(string), [])<br>      api_keys           = optional(list(string), [])<br>    })<br>  )</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Data structure
```
Data structure
---------------
A list of dictionaries, where each dictionary has the following attributes:

REQUIRED
---------
- suffix                : Suffix to use when creating the RESTAPI Gateway
- open_api_file_path    : Path to OpenAPI definition file
- description           : A human-friendly description of the API


OPTIONAL
---------
- template_input        : A dictionary of variable input for the OpenAPI definition file (leave blank if no template required)
- allowed_lambdas       : A list of strings, where each string is the function_name of a lambda to allow access to.
- quota_limit           : Maximum number of requests that can be made in a given time period, defaults to 10.
- quota_offset          : Number of requests subtracted from the given limit in the initial time period, defaults to 0.
- quota_period          : Time period in which the limit applies. Valid values are "DAY", "WEEK" or "MONTH". Defaults to "DAY"
- burst_limit           : The API request burst limit, the maximum rate limit over a time ranging from one to a few seconds, depending upon whether the underlying token bucket is at its full capacity. Defaults to 5.
- rate_limit            : The API request steady-state rate limit, defaults to 10.
- api_keys              : List of strings, where each string is name of an API key to create for the API, defaults to empty list.
```

## Examples
See `examples` folder for an example setup.
