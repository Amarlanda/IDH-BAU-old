
Import-Module AWSPowerShell 

################
###AWS Key check
#################
## get list of keys Get-AWSCredentials -ListProfileDetail
##if -not AWS key exsists 
## Set-AWSCredential -AccessKey AKIAJAGKPACAM5XWPZGQ -SecretKey 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 -StoreAs AJ-AWS-LAB
## now run this to see the new profile
## get list of keys Get-AWSCredentials -ListProfileDetail
##Initialize-AWSDefaults -ProfileName AJ-AWS-LAB -Region eu-west-2

################

$imageshash = @{} 
$instanceshash = @{} 


$currentkey = "InfraDev"

#set shell varibles 

  #Loop through AWS keys/profiles
    set AWS_PROFILE=$currentkey
    aws ec2 describe-images

#set powershell varibles

<#$cred = Get-AWSCredential -ListProfileDetail  

$cred| ForEach-Object {

        Get-EC2Region -ProfileName $($_.profilename) -Filter *
        
    }
    #>
Get-EC2AvailabilityZone -Region eu-west-1 -ProfileName InfraDev | ForEach-Object {

    Get-EC2Instance -Region eu-west-1 -ProfileName InfraDev

}

#$images = Get-EC2Image -ProfileName InfraDev -Region eu-west-1

$instancesNEW = $instances | foreach-object {

    $_ | select *, @{n='ImageName';e={$($imageshash.Get_Item($_.imageid)).name }}

}


