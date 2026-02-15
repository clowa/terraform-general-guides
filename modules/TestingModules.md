# Testing terraform modules

## Key testing takeaways

1. When testing Terraform code, there is no place like 127.0.0.1
   Therefore, you need to do all of your testing by deploying real resources into one or more isolated sandbox environments.
2. Regularly cleanup your sandbox environment.
   Otherwise, the environment will become unmanageable, and costs will spiral out of control.
   You can use tools like:
   * [cloud-nuke](https://github.com/gruntwork-io/cloud-nuke)
   * [aws-nuke](https://github.com/rebuy-de/aws-nuke)
   * [Swabbie](https://github.com/spinnaker/swabbie) (further Janitor Monkey)
3. You cannot do pure unit testing for terraform code.
   However, you can write tests to deploy units of terraform aka. modules into real world and test this infrastructure. Therefore, you have to do all of your automated testing by writing code that deploys real resources into  one or mode isolated sandbox environments.
4. Smaller modules are easier and faster to test
   Smaller modules are easier to create, maintain, use, and test.

## Testing pyramid

![Testing pyramid](https://miro.medium.com/max/1400/1*Tcj3OsK8Kou7tCMQgeeCuw.png)

You should aiming for a large number of [unit tests](#unit-tests), a smaller number of [integration tests](#integration-tests), and a very small number of [end-to-end tests](#end-to-end-tests). This is because, as you go up the pyramid , the cost and complexity of writing the test, the brittleness of the test, and the runtime of the tests all increase.

## Unit tests

Unit tests verify the functionality of a single, small unit of code.
The definition of a _unit_ varies, but in a general-purpose programming language, it's typically a single function or class. Usually, any external dependencies - for example, databases, web services, even filesystem - are replaced with _test doubles_ or _mocks_ that allow you to finely control the behavior of those dependencies (e.g. by returning a hard-coded response from a database mock) to test that your code handles a variety of scenarios.

[See an example unit test written in go](https://github.com/brikis98/terraform-up-and-running-code/blob/master/code/terraform/07-testing-terraform-code/test/alb_example_test.go)

### Basic strategy

You do exactly the same steps as you would when doing manual testing, but you capture those steps as code. In fact, just ask yourself: "How would I have tested this manually to be confident it works?" and then implement that in code.

1. Create a generic, standalone module
2. Create an easy-to-deploy example for that module. You should always do this to document your code.
3. Run `terraform apply` to deploy the example into a real environment.
4. Validate that what your just deployed works as expected. This step is specific to the type of infrastructure you're testing: for example, for an ALB you'd validate it by sending an HTTP request and checking that you received back the expected response.
5. Run `terraform destroy` at the end of the test to clean up.

## Integration tests

Integration test verify that multiple units work together correctly. In a general-purpose programming language, an integration test consist of code that validates that several functions or classes work together correctly. Integration tests typically use a mix of real dependencies and mocks: for example, if you're testing the part of your app that communicates with the database, you might want to test it with a real database, but mock out other dependencies, such as the app's authentication system.

[See an example integration test written in go](https://github.com/brikis98/terraform-up-and-running-code/blob/master/code/terraform/07-testing-terraform-code/test/hello_world_integration_test.go)

## End-to-end tests

End-to-end test involve running your entire architecture - for example, your apps, your data stores, your load balancers - and validating that your system works as a whole. Usually, these test are done from the end-user's  perspective, such as using Selenium to automate interacting with your product via a web browser. End-to-end test typically use real systems everywhere, without any mocks, in an architecture that mirrors production (albeit with fewer/smaller servers to save money).

## Useful tools

### testing tools

* [Terratest](https://github.com/gruntwork-io/terratest): Golang Unit testing library for terraform modules. See the [official website](https://terratest.gruntwork.io/) and get hands on at [Getting started](https://terratest.gruntwork.io/docs/getting-started/quick-start/)

### Static analysis

You can use several tools to test your terraform code without running it and deploy anything. Take a look to the following list:

* `terraform validate`
   This is a build-in command of terraform you can use to check terraform syntax and  types (a bit like a compiler).
* [tfint](https://github.com/wata727/tflint)
  A "lint" tool for terraform that can scan your terraform code and catch common errors and potential bugs based on a set of build-in rules.
* [Hashicorp Sentinel](https://www.hashicorp.com/sentinel)
  A "policy as code" framework that allows you to enforce rules across various Hashicorp tools. For example, you could create a policy to disallow security group rules in your Terraform code that allow inbound access from `0.0.0.0/0`. As of this writing, Sentinel is available only with Hashicorp enterprise products, including terraform enterprise.

### Property testing

The following tools can be used to validate specific "properties" of your terraform infrastructure.
Most of these tools use a _domain-specific-language_ (DSL) for checking that your deployed infrastructure conforms to some sort of specification, eg.

```
describe file('/etc/myapp.conf') do
   it { should exist }
   its('mode') { should cmp 0644 }
end
```

* [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform)
* [rspec-terraform](https://github.com/bsnape/rspec-terraform)
* [serverspec](https://serverspec.org)
* [inspec](https://www.inspec.io)
* [goss](https://github.com/aelsabbahy/goss)
