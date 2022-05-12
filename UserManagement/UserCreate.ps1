#--------------------------------[Prerequisites]-------------------------------------------------
# *File should be run on the SERVER in the C:\Users\Administrator directory
# *You need the database to be located in this same folder
# *Group "maingroup" should exist in AD already
# *Shared folder for "$MainGroup" has to exist
# *Shared folder for "$Moderator" has to exist

#Open powershell in the correct directory and use .\UserCreate to run this script  

#------------------------------------------------------------------------------------------------


$ADServer = "\\ActiveDirectory-SERVER"
$FileServer = "\\ActiveDirectory-SERVER"
$DC = "DC=DOMAIN, DC=be"
$Domain = "DOMAIN"
$MainGroup = "PRIMARYGROUP"
$Group = "GROUP"
$Moderator= "MODERATOR"

$year = (Get-Date).year + 1
$DatabaseGroup = "subgroup"
$DatabasePrimaryGroup = "primarygroup"

$MainFolder= "PRIMARYFOLDER"
$CSVFolder = "c:\temp\userexport.csv"
$SharedFolder = "sharedfolder"

# Creates groups
Function CreateGroups()
{
  # Variables for later use
  $DatabaseName = 'DATABASE.accdb'
  $GetClassesQuery = "SELECT distinct $DatabaseGroup FROM $DatabasePrimaryGroup;"
  $ConnectionString = "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=$DatabaseName" #check for correct version

  # Connecting to the Access Database
  $DbConnection = New-Object System.Data.OleDb.OleDbConnection($ConnectionString)
  $DbConnection.Open()

  # Preparing the query
  $DbCommand = $DbConnection.CreateCommand()
  $DbCommand.CommandText = $GetClassesQuery

  # Creating a Reader
  $Reader = $DbCommand.ExecuteReader()
  $Datatable = New-Object System.Data.Datatable

  # Run this in a Try-Catch to not crash the script in case a record isn't found.
  Try
  {
    $Datatable.Load($Reader)

    # Looping through the records
    Foreach ($ClassRecord in $Datatable)
    {
      # Get the data from the 'group' record
      $SubGroup = $ClassRecord.group #Create new OU Per group

      Write-Host "SubGroup: $SubGroup"
     
       # Create a new AD Group for the class
      #$OUObject = Get-ADOrganizationalUnit -Filter ("distinguishedName -eq '$SubGroup'")
      #$OUObject = Get-ADOrganizationalUnit -Identity "OU=$SubGroup,OU=$MainGroup,$DC"
      
      try
      {
        Get-ADOrganizationalUnit -Identity "OU=$SubGroup,OU=$MainGroup,$DC"
        Write-Host "$SubGroup already exists."
      }
      catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
      {
        Write-Host "Creating OU $SubGroup"
        New-ADOrganizationalUnit -Name $SubGroup -Path "OU=$MainGroup,$DC" -ProtectedFromAccidentalDeletion $False
      }
       
      $GroupObject = Get-ADGroup -LDAPFilter "(SAMAccountName=$SubGroup)"
      #testing new OU unit
      #New-ADOrganizationalUnit -Name "$SubGroup" -Path "OU=$MainGroup,$DC"
      if($GroupObject -eq $null)
      {
        New-ADGroup -Name $SubGroup -SamAccountName $SubGroup -GroupCategory Security -GroupScope Global -DisplayName $SubGroup -Path "OU=$SubGroup,OU=$MainGroup,$DC" -Description "$MainGroup Member of $SubGroup"     
        Add-ADGroupMember -Identity $MainGroup -Members $SubGroup   
        Write-Host "Creating group: $SubGroup"
      }
      # [ Folder creation ]
      $GroupFolder = $ClassRecord.group 
      # Test if the remote folder exists
      $FolderExists = Test-Path -Path "$ADServer\$MainFolder\$GroupFolder"
      If (-not $FolderExists)
      {
        # If the class folder doesn't exist we create it
        New-Item -Path "$ADServer\$MainFolder\" -Name $GroupFolder -ItemType 'Directory'
        Write-Host "creating class"
      }

      # Test if the remote folder exists
      $FolderExists = Test-Path -Path "$ADServer\$MainFolder\$GroupFolder\$SharedFolder"
      If (-not $FolderExists)
      {
        # If the $SharedFolder folder doesn't exist we create it
        New-Item -Path "$ADServer\$MainFolder\$GroupFolder" -Name "$SharedFolder" -ItemType 'Directory'
        Write-Host "creating folder"
      }

      # [ ACL rights for the folder ]
      #------------------------------------------------------------------------------
      # Update ACL policy of $SharedFolder folder: Adding the classgroup to the security
      $ACL$SharedFolder = Get-Acl -Path "$ADServer\$MainFolder\$GroupFolder\$SharedFolder"
      # User that gains rights
      $ACLIdentity = "$Domain\$SubGroup" #"$Domain\$SubGroup"
      # The rights that will be given
      $ACLRights = "ReadAndExecute"
      # Allow/Deny the ACL rules
      $ACLPropagationFlags = 0 #None

      # Allow/Deny the ACL rules
      $ACLType = 0 #Allow

      $ACLInheritanceFlags = "ContainerInherit, ObjectInherit"
      #Debugging------------------------------
      $DebugPath = Resolve-Path $Acl$SharedFolder.Path
      Write-Host "Debugpath: $DebugPath"
      Write-Host "acl: "
      Write-Host ($ACL$SharedFolder | Format-Table | Out-String)
      Write-Host "acl accessrule: $ACLAccessRule"
      Write-Host ($ACLAccessRule | Format-Table | Out-String)
      #Debugging------------------------------
      # Create the ACL object using the arguments set by the variables
     $ACLArguments = $ACLIdentity, $ACLRights,$ACLInheritanceFlags, $ACLPropagationFlags,$ACLType
     
      $ACLAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ACLArguments
      # Apply the ACL rule and set it to the \\FS-LLN\$SubGroup\$SharedFolder folder
      $ACL$SharedFolder.SetAccessRule($ACLAccessRule)
      $ACL$SharedFolder.SetAccessRuleProtection($false,$true)

      #Recursive enheritence

      Set-Acl -Path "$ADServer\$MainFolder\$GroupFolder\$SharedFolder" -AclObject $ACL$SharedFolder
      #-----------------------------------------------------------------------------------------


      #------------------------------------------------------------------------------
      # Update ACL policy of $SharedFolder folder: Adding the classgroup to the security
      $ACL$SharedFolder = Get-Acl -Path "$ADServer\$MainFolder\$GroupFolder\$SharedFolder"
      # User that gains rights
      $ACLIdentity = "$Domain\$Moderator" #"$Domain\$SubGroup"
      # The rights that will be given
      $ACLRights = "Modify"
      $ACLInheritanceFlags = "ContainerInherit, ObjectInherit"
      $ACLPropagationFlags = 0 #None

      # Allow/Deny the ACL rules
      $ACLType = 0 #Allow
      #Debugging------------------------------
      $DebugPath = Resolve-Path $Acl$SharedFolder.Path
      Write-Host "Debugpath: $DebugPath"
      Write-Host "acl: "
      Write-Host ($ACL$SharedFolder | Format-Table | Out-String)
      Write-Host "acl accessrule: $ACLAccessRule"
      Write-Host ($ACLAccessRule | Format-Table | Out-String)
      #Debugging------------------------------
      # Create the ACL object using the arguments set by the variables
      $ACLArguments = $ACLIdentity, $ACLRights,$ACLInheritanceFlags, $ACLPropagationFlags,$ACLType
      
      $ACLAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ACLArguments
      # Apply the ACL rule and set it to the \\FS-LLN\$SubGroup\$SharedFolder folder
      $ACL$SharedFolder.SetAccessRule($ACLAccessRule)
      $ACL$SharedFolder.SetAccessRuleProtection($false,$true)

      Get-Item "$ADServer\$MainFolder\$GroupFolder\$SharedFolder"
      
      #Recursive Enheritence
      # $AllFolders = Get-ChildItem -Path "$ADServer\$MainFolder\$SubGroup\$SharedFolder" -Directory -Recursive
      # Foreach($Folder in $AllFolders)
      # {

      # }

      Set-Acl -Path "$ADServer\$MainFolder\$GroupFolder\$SharedFolder" -AclObject $ACL$SharedFolder
      #-----------------------------------------------------------------------------------------

      #Debugging--------------------------------------------------------------------------------
      Write-Host "acl: "
      Write-Host ($ACL$SharedFolder | Format-Table | Out-String)
      #Debugging---------------------------------------------
    }
  }
  Catch [System.Data.OleDb.OleDbException]
  {
    Write-Host 'Cannot find record'
  }

  $DbConnection.Close()
}
Function CreateUsers()
{
  # [ Database Connection ]
  # Variables for later use
  $DatabaseName = '$MainGroup.accdb'
  $GetClassesQuery = 'SELECT * FROM lln order by surname, name, group;'
  $ConnectionString = "Provider = Microsoft.ACE.OLEDB.12.0;Data Source=$DatabaseName"

  # Connecting to the Access Database
  $DbConnection = New-Object System.Data.OleDb.OleDbConnection($ConnectionString)
  $DbConnection.Open()

  # Preparing the query
  $DbCommand = $DbConnection.CreateCommand()
  $DbCommand.CommandText = $GetClassesQuery

  # Creating a Reader
  $Reader = $DbCommand.ExecuteReader()
  $Datatable = New-Object System.Data.Datatable

  # Create an Excel application, open the lln file and go to the first sheet
  # $Excel = New-Object -ComObject Excel.Application
  # $Workbook = $Excel.Workbooks.Open("$FileServer\$Moderator\Gunther Van Bleyenbergh\$MainGroup\lln_ad2019.xlsx")
  # $Worksheet = $WorkBook.Sheets.Item(1)

  # Rename the first sheet to '$MainGroup'
  # $Worksheet.name = '$MainGroup'

  $ExcelRow = 2

  # Run this in a Try-Catch to not crash the script in case a record isn't found.
  Try
  {
    $Datatable.Load($Reader)
    $PreviousName = ''
    # Looping through the records
    Foreach ($Record in $Datatable)
     {
       # Get the first letter of your first name (*B*eau)
       $CurrentName = $Record.name.Substring(0, 1).ToLower()
       Write-Host "currentname 1: $CurrentName"

       # Get an array of all the last names
       $LastNames = -split $Record.surname

       # Combine the first name and the last names
       Foreach ($LastName in $LastNames)
       {
         $CurrentName = -join ($CurrentName, $LastName)
         Write-Host "currentname 2: $CurrentName"
         Write-Host "lastname 1: $LastName"
       }

       # If the name is a duplicate we add a 2
       # TODO: Update to use a counter for each dupe
       If ($CurrentName -eq $PreviousName)
       {
         $CurrentName = -join ($CurrentName, '2') #Edit for multiples
         Write-Host "currentname 3: $CurrentName"
       }
          # Replace non-email-friendly symbols
     
        $CurrentName = Remove-StringLatinCharacters -String $CurrentName
      

        # NOTE: This might actually be 14
        $CurrentName = $CurrentName.ToLower()
        if($CurrentName.length -ge 14)
        {
          $CurrentName = $CurrentName.Substring(0, 14)
        }
        # Write the user info in the sheet
        # $WorksheetCells.Item($ExcelRow, 1) = $Record.group
        # $WorksheetCells.Item($ExcelRow, 2) = $Record.surname
        # $WorksheetCells.Item($ExcelRow, 3) = $Record.name
        # $WorksheetCells.Item($ExcelRow, 4) = $CurrentName
        Write-Host "group: $($Record.group), surname: $($Record.surname), name: $($Record.name), currentname: $CurrentName"
        # Increase the row count
        $ExcelRow = $ExcelRow + 1
        # [ Create Home Directory ]
        # Parameters for user creation 
        $SubGroup = $Record.group
        $GroupFolder = $Record.group
        $Email = -join ($CurrentName, '@Handelsschoolaalst.be')
        $Displayname = -join ($Record.name, ' ', $Record.surname)
        $GivenName = $Record.name
        $Surname = $Record.surname
        $Description = -join ($MainGroup, $SubGroup)
        $LogonScript = -join ($Record.group, '.bat')
        $HomeDirectory="$ADServer\$MainFolder\$GroupFolder\$CurrentName"
        #set standard password
        $Password = ConvertTo-SecureString "Abcde123" -AsPlainText -Force

        

        $FolderExists = Test-Path -Path "$ADServer\$MainFolder\$GroupFolder\$CurrentName"
        If (-not $FolderExists)
        {
          # If the class folder doesn't exist we create it
          New-Item -Path "$ADServer\$MainFolder\$GroupFolder\" -Name $CurrentName -ItemType 'directory'
          Write-Host "creating userfolder"
        }

       # NOTE: Shouldn't we use the actual given names and surnames? testing
       $UserExists = Get-ADUser -LDAPFilter "(SAMAccountName=$CurrentName)"
       if($UserExists -eq $null)
       {
        New-ADUser -Name $Email -SamAccountName $CurrentName -GivenName $GivenName -Surname $Surname -UserPrincipalName $Email -DisplayName $Displayname -EmailAddress $Email -Path "OU=$SubGroup,OU=$MainGroup,$DC" -Description $Description -ScriptPath $LogonScript -Title $Description -Company 'Company' -HomeDirectory $HomeDirectory -HomeDrive 'U:' -Enabled $True -AccountPassword $Password -ChangePasswordAtLogon:$true
        Add-ADGroupMember -Identity $SubGroup -Members $CurrentName
        $CurrentGroupOutput = Get-ADPrincipalGroupMembership -Identity $CurrentName
        Write-Host "creating current user: $CurrentName"
        Write-Host "Adding Member: $CurrentName to Group: $CurrentGroupOutput"
       }
 
        # [ Set home directory permissions ]
        #--------------ACL for LEERLING and his own folder-------------------
        $ACL$SharedFolder = Get-Acl -Path $HomeDirectory
        # Student gets rights on his own home directory
        $ACLIdentity = "$Domain\$CurrentName" #"$Domain\$SubGroup"
        # The rights that will be given
        $ACLRights = "Modify, Write, Delete"
        $ACLInheritanceFlags = "ContainerInherit, ObjectInherit"
        $ACLPropagationFlags = 0 #None

        # Allow/Deny the ACL rules
        $ACLType = 0 #Allow
        # Create the ACL object using the arguments set by the variables
       $ACLArguments = $ACLIdentity, $ACLRights,$ACLInheritanceFlags, $ACLPropagationFlags,$ACLType
   
        $ACLAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ACLArguments
        # Apply the ACL rule and set it to the \\DOMAIN\$SubGroup\$SharedFolder folder
        $ACL$SharedFolder.SetAccessRule($ACLAccessRule)
        $ACL$SharedFolder.SetAccessRuleProtection($false,$true)
        Set-Acl -Path "$HomeDirectory" -AclObject $ACL$SharedFolder

        Get-Item "$HomeDirectory"
      
        #----------------------------------------------------------------------

        #--------------ACL for MODERATOR and his own folder-------------------
        $ACL$SharedFolder = Get-Acl -Path $HomeDirectory
        # Student gets rights on his own home directory
        $ACLIdentity = "$Domain\$Moderator" 
        # The rights that will be given
        $ACLRights = "Modify"
        $ACLInheritanceFlags = "ContainerInherit, ObjectInherit"
        $ACLPropagationFlags = 0 #None

        # Allow/Deny the ACL rules
        $ACLType = 0 #Allow
        # Create the ACL object using the arguments set by the variables
        $ACLArguments = $ACLIdentity, $ACLRights,$ACLInheritanceFlags, $ACLPropagationFlags, $ACLType

        $ACLAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ACLArguments
        # Apply the ACL rule and set it to the \\FS-LLN\$SubGroup\$SharedFolder folder
        $ACL$SharedFolder.SetAccessRule($ACLAccessRule)
        $ACL$SharedFolder.SetAccessRuleProtection($false,$true)

        Get-Item "$HomeDirectory" 
        
        Set-Acl -Path "$HomeDirectory" -AclObject $ACL$SharedFolder
        #----------------------------------------------------------------------

        # Set the previous name to the current name, used to catch duplicates
        $PreviousName = $CurrentName

     }

  }
  #PswLastSet
  Catch [System.Data.OleDb.OleDbException]
  {
    Write-Host 'Cannot find record'
  }
   # Save the workbook, close it and end the DB connection
  #  $Workbook.Save()
  #  $Workbook.Close($True)
   $DbConnection.Close()



}
function Remove-StringLatinCharacters
{
    PARAM ([string]$String)
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String))
}
#546f7a834903dca60a5865264c2d029d1c5d705a
CreateGroups
CreateUsers
