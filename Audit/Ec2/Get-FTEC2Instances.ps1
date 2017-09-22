$instances= Get-EC2Instance -Region eu-west-1 -ProfileName InfraDev |
select *,
@{n='Name';e={$($_.tag).Name}},
@{n='imageid';e={$($_.instances).ImageId}},
@{n='environment';e={$($_.tag).environment}},
@{n='ipCode';e={$($_.tag).ipCode}},
@{n='teamDL';e={$($_.tag).teamDL}},
@{n='description';e={$($_.tag).description}},
@{n='stopSchedule';e={$($_.tag).stopSchedule}},
@{n='systemCode';e={$($_.tag).systemCode}},
@{n='obj';e={$_}}

$instanceshash = @{}

$instances | foreach-object {

    $instanceshash.Add($_.imageid, $_)

}



## Query ImageID Ahead of time

###RE-WRITE use the json to avoide nested hashtables.
