$FileserverLLN = "\\FS-LLN"
$FileserverPERS = "\\FS-Personeel"
$DC = "DC=Handelsschoolaalst, DC=be"

$FileserverLLN = "\\WIN-8KV6AGI5ESN"
$FileserverPERS = "\\WIN-8KV6AGI5ESN"
$DC = "DC=TEST, DC=be"
# Creates groups
Function CreateGroups()
{
  # Variables for later use
  $DatabaseName = 'leerlingen.accdb'
  $GetClassesQuery = 'SELECT distinct klas FROM lln;'
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
      # Get the data from the 'klas' record
      $GroupName = $ClassRecord.klas #Create new OU Per klas
      Write-Host "Groupname: $GroupName"
      # Create a new AD Group for the class
      $GroupObject = Get-ADGroup -LDAPFilter "(SAMAccountName=$GroupName)"
      if($GroupObject -eq $null)
      {
        New-ADGroup -Name $GroupName -SamAccountName $GroupName -GroupCategory Security -GroupScope Global -DisplayName $GroupName -Path "OU=leerlingen,$DC" -Description "Leerlingen in deze groep maken deel uit van klas $GroupName"
        Write-Host "Creating group: $GroupName"
      }



      # [ Folder creation ]
      # Test if the remote folder exists
      $FolderExists = Test-Path -Path "$FileserverLLN\leerlingen\$GroupName"
      If (-not $FolderExists)
      {
        # If the class folder doesn't exist we create it
        New-Item -Path "$FileserverLLN\leerlingen\" -Name $GroupName -ItemType 'Directory'
        Write-Host "creating class"
      }

      # Test if the remote folder exists
      $FolderExists = Test-Path -Path "$FileserverLLN\leerlingen\$GroupName\Opdrachten"
      If (-not $FolderExists)
      {
        # If the opdrachten folder doesn't exist we create it
        New-Item -Path "$FileserverLLN\leerlingen\$GroupName" -Name 'Opdrachten' -ItemType 'Directory'
        Write-Host "creating folder"
      }

      # [ ACL rights for the folder ]
      # Update ACL policy of Opdrachten folder
      $ACLOpdrachten = Get-Acl -Path "$FileserverLLN\leerlingen\$GroupName\Opdrachten"

      # User that gains rights
      $ACLIdentity = "TEST\$GroupName"

      # The rights that will be given
      $ACLRights = 'Modify'

      # Allow/Deny the ACL rules
      $ACLType = 'Allow'

      # Create the ACL object using the arguments set by the variables
      $ACLArguments = $ACLIdentity, $ACLRights, $ACLType
      $ACLAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ACLArguments

      # Apply the ACL rule and set it to the \\FS-LLN\$GroupName\Opdrachten folder
      $ACLOpdrachten.SetAccessRule($ACLAccessRule)
      Set-Acl -Path "$FileserverLLN\leerlingen\$GroupName\Opdrachten" -AclObject $ACLOpdrachten
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
  $DatabaseName = 'leerlingen.accdb'
  $GetClassesQuery = 'SELECT * FROM lln order by naam, voornaam, klas;'
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
  # $Workbook = $Excel.Workbooks.Open("$FileserverPERS\leerkrachten\Gunther Van Bleyenbergh\Leerlingen\lln_ad2019.xlsx")
  # $Worksheet = $WorkBook.Sheets.Item(1)

  # Rename the first sheet to 'leerlingen'
  # $Worksheet.name = 'leerlingen'

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
       $CurrentName = $Record.voornaam.Substring(0, 1).ToLower()
       Write-Host "currentname 1: $CurrentName"

       # Get an array of all the last names
       $LastNames = -split $Record.naam

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
         $CurrentName = -join ($CurrentName, '2') #Edit for multilples
         Write-Host "currentname 3: $CurrentName"

       }
          # Replace non-email-friendly symbols
      # $CurrentName = $CurrentName -replace "'",''
      # $CurrentName = $CurrentName -replace "-",''
      # $CurrentName = $CurrentName -replace "ú",'u'
      # $CurrentName = $CurrentName -replace "ù",'u'
      # $CurrentName = $CurrentName -replace "ü",'u'
      # $CurrentName = $CurrentName -replace "Ü",'u'
      # $CurrentName = $CurrentName -replace "é",'e'
      # $CurrentName = $CurrentName -replace "è",'e'
      # $CurrentName = $CurrentName -replace "ë",'e'
      # $CurrentName = $CurrentName -replace "Ë",'e'
      # $CurrentName = $CurrentName -replace "à",'a'
      # $CurrentName = $CurrentName -replace "ä",'a'
      # $CurrentName = $CurrentName -replace "Ä",'a'
      # $CurrentName = $CurrentName -replace "ö",'o'
      # $CurrentName = $CurrentName -replace "Ö",'o'
      # $CurrentName = $CurrentName -replace "Ú",'e'
      # $CurrentName = $CurrentName -replace "Ï",'I'
      # $CurrentName = $CurrentName -replace "ç",'c'

        # NOTE: This might actually be 14
        $CurrentName = $CurrentName.ToLower()
        if($CurrentName.length -ge 14)
        {
          $CurrentName = $CurrentName.Substring(0, 14)
        }
       

        # Write the user info in the sheet
        # $WorksheetCells.Item($ExcelRow, 1) = $Record.klas
        # $WorksheetCells.Item($ExcelRow, 2) = $Record.naam
        # $WorksheetCells.Item($ExcelRow, 3) = $Record.voornaam
        # $WorksheetCells.Item($ExcelRow, 4) = $CurrentName
        Write-Host "klas: $($Record.klas), naam: $($Record.naam), voornaam: $($Record.voornaam), currentname: $CurrentName"

        # Increase the row count
        $ExcelRow = $ExcelRow + 1
          # [ Create Home Directory ]
     

      # Parameters for user creation
      $GroupName = $Record.klas
      $Email = -join ($CurrentName, '@Handelsschoolaalst.be')
      $Displayname = -join ($Record.voornaam, ' ', $Record.naam)
      $Description = -join ('Leerling ', $Record.klas)
      $LogonScript = -join ($Record.Klas, '.bat')
      $HomeDirectory="$FileserverLLN\leerlingen\$GroupName\$CurrentName"
      $Password = ConvertTo-SecureString "Abcde123" -AsPlainText -Force

      

      $FolderExists = Test-Path -Path "$FileserverLLN\leerlingen\$GroupName\$CurrentName"
      If (-not $FolderExists)
      {
        # If the class folder doesn't exist we create it
        New-Item -Path "$FileserverLLN\leerlingen\$GroupName\" -Name $CurrentName -ItemType 'directory'
        Write-Host "creating userfolder"
      }

       # NOTE: Shouldn't we use the actual given names and surnames? testing
       $UserExists = Get-ADUser -LDAPFilter "(SAMAccountName=$CurrentName)"
       if($UserExists -eq $null)
       {
        New-ADUser -Name $Email -SamAccountName $CurrentName -GivenName $CurrentName -Surname $CurrentName -UserPrincipalName $Email -DisplayName $Displayname -Description $Description -ScriptPath $LogonScript -Title $Description -Company 'Dé Handelsschool Aalst' -HomeDirectory $HomeDirectory -HomeDrive 'U:' -Enabled $True -AccountPassword $Password
        Write-Host "creating current user: $CurrentName"
       }

       

       # [ Set home directory permissions ]
       $ACLOpdrachten = Get-Acl -Path $HomeDirectory

       # Student gets rights on his own home directory
       $ACLIdentity = "TEST\$CurrentName"

       # The rights that will be given
       $ACLRights = 'Modify'

       # Allow/Deny the ACL rules
       $ACLType = 'Allow'

        # Create the ACL object using the arguments set by the variables
      $ACLArguments = $ACLIdentity, $ACLRights, $ACLType
      $ACLAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ACLArguments

      # Apply the ACL rule and set it to the \\FS-LLN\$GroupName\Opdrachten folder
      $ACLOpdrachten.SetAccessRule($ACLAccessRule)
      Set-Acl -Path "$FileserverLLN\leerlingen\$GroupName\Opdrachten" -AclObject $ACLOpdrachten

      # Set the previous name to the current name, used to catch duplicates
      $PreviousName = $CurrentName

     }

  }
  Catch [System.Data.OleDb.OleDbException]
  {
    Write-Host 'Cannot find record'
  }
   # Save the workbook, close it and end the DB connection
  #  $Workbook.Save()
  #  $Workbook.Close($True)
   $DbConnection.Close()


}

CreateGroups
CreateUsers
