variable "environment" {
  description = "Which environment this is being instantiated in."
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Must be either dev, test or prod"
  }
}

variable "application_name" {
  description = "Name of the application utilising resource."
  type        = string
}

variable "raw_api_gateway_rest_apis" {
  description = <<EOF

Data structure
---------------
A list of dictionaries, where each dictionary has the following attributes:

REQUIRED
---------
- suffix                : Suffix to use when creating the RESTAPI Gateway
- open_api_file_path    : Path to OpenAPI definition file
- description           : A human-friendly description of the API
- tags                  : A dictionary of tags, required to tag Stage to ensure its protected by WAF.


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

EOF
  type = list(
    object({
      suffix             = string,
      description        = string,
      tags               = map(string),
      open_api_file_path = string,
      template_input     = optional(map(string), {}),
      quota_limit        = optional(number, 10),
      quota_offset       = optional(number, 0),
      quota_period       = optional(string, "DAY"),
      burst_limit        = optional(number, 5),
      rate_limit         = optional(number, 10)
      allowed_lambdas    = optional(list(string), [])
      api_keys           = optional(list(string), [])
    })
  )
  validation {
    condition = alltrue([
      for api in var.raw_api_gateway_rest_apis : (api.quota_limit >= 0)
    ])
    error_message = "quota_limit must be greater than or equal to 0"
  }

  validation {
    condition = alltrue([
      for api in var.raw_api_gateway_rest_apis : (api.quota_offset >= 0)
    ])
    error_message = "quota_offset must be greater than or equal to 0"
  }

  validation {
    condition = alltrue([
      for api in var.raw_api_gateway_rest_apis : contains(["DAY", "WEEK", "MONTH"], api.quota_period)
    ])
    error_message = "quota_period must be one of the following: DAY, WEEK, MONTH"
  }

  validation {
    condition = alltrue([
      for api in var.raw_api_gateway_rest_apis : (api.burst_limit >= 0)
    ])
    error_message = "burst_limit must be greater than or equal to 0"
  }

  validation {
    condition = alltrue([
      for api in var.raw_api_gateway_rest_apis : (api.rate_limit >= 0)
    ])
    error_message = "rate_limit must be greater than or equal to 0"
  }
}