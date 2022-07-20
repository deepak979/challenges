$InputObject = @"
{
  "a":{
    "b":{
      "c":"d"
    }
  }
}
"@

function GetKeyValue {
  param (
    $InputObject,
    $KeyToMatch
  )
  $PSInputObject = $InputObject | ConvertFrom-Json
  $Properties = $PSInputObject.PsObject.Properties
  foreach ($property in $Properties) {
    if ($property.Name -eq $keyToMatch) {
      Write-Output "Value for key $($KeyToMatch) is $($PSInputObject.$KeyToMatch | ConvertTo-Json)"
    }
    elseif ($property.TypeNameOfValue -ne "System.String") {
      GetKeyValue -InputObject ($property.Value | ConvertTo-Json) -KeyToMatch $KeyToMatch
    }
    else {
      Write-Output "Key $($KeyToMatch) not matching any value"
    }
  }
  
}
GetKeyValue -InputObject $InputObject -KeyToMatch "a"
