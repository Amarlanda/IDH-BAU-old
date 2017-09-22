################
###AWS Key check
#################
## get list of keys Get-AWSCredential -ListProfileDetail
##if -not AWS key exsists 
##Set AWS Profile 
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


