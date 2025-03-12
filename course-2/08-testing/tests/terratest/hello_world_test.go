package main

import (
	"crypto/tls"
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestHelloWorld(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../modules/hello-world",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// must have http://
	instanceURL := fmt.Sprintf("http://%s:80", terraform.Output(t, terraformOptions, "instance_ip_addr"))

	tlsConfig := tls.Config{}
	maxRetries := 30
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t, instanceURL, &tlsConfig, maxRetries, timeBetweenRetries, validate,
	)
}

func validate(status int, body string) bool {
	fmt.Println(body)
	return status == 200
}
