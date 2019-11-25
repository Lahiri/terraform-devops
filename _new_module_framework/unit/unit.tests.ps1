## This file includes all unit tests that must be executed for the module.

Set-Location $PSScriptRoot/..
Import-Module Pester -RequiredVersion $env:PesterVersion

$config_files = Get-ChildItem -Filter "config*.tfvars" -Recurse

az login --service-principal -u $env:ARM_CLIENT_ID -p $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID

Describe "terraform setup" {
    It "terraform init"{
        terraform init
    }
}

Foreach ($config in $config_files)
{
    Describe "[$( $config.BaseName )] unit test"{
        Context "Output generation"{
            It "terraform plan"{
                {
                    terraform plan -var-file $($config.FullName) -out="output"
                } | Should Not Throw
            }

            It "read output" {
                {
                    $output_file = $("out_" + $($config.BaseName).Split('.')[0])
                    $Script:output = terraform show -json "output" | ConvertFrom-Json
                } | Should Not Throw
            }
        }
        Context "Output should match input parameters" {

            It "resource_group_name" {
                $input_value = $Script:output.variables.resource_group_name.value

                foreach($resource in ($Script:output.planned_values.root_module.child_modules[0].resources)){
                    $planned_value = $resource.values.resource_group_name

                    $input_value | Should -BeExactly $planned_value
                }

            }

<#
            It "<input-variable>" {
                $input_value = $Script:output.variables.<input-variable>.value
                $planned_value = ($Script:output.planned_values.root_module.child_modules[0].resources | Where-Object {$_.name -eq "nic"}).values.<path-to-applied-value>

                $input_value | Should -BeExactly $planned_value
            }
#>

            AfterAll {
                Remove-Item .\output
            }
        }
    }
}