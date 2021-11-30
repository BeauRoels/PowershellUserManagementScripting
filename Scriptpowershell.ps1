# Creates groups
Function CreateGroups()
{
  # Variables for later use
  $DatabaseName = 'leerlingen.accdb'
  $GetClassesQuery = 'SELECT distinct klas FROM lln;'
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

  # Run this in a Try-Catch to not crash the script in case a record isn't found. 
  Try
  {
    $Datatable.Load($Reader)

    # Looping through the records
    Foreach ($ClassRecord in $Datatable)
    {
      # Get the data from the 'klas' record
      $GroupName = $ClassRecord.klas

      # Create a new AD Group for the class
      New-ADGroup -Name $GroupName -SamAccountName $GroupName -GroupCategory Security -GroupScope Global -DisplayName $GroupName -Path 'OU=leerlingen,DC=Handelsschoolaalst,DC=be' -Description "Leerlingen in deze groep maken deel uit van klas $ClassName"

      # [ Folder creation ]
      # Test if the remote folder exists
      $FolderExists = Test-Path -Path "\\FS-LLN\leerlingen\$ClassName"
      If (-not $FolderExists)
      {
        # If the class folder doesn't exist we create it  
        New-Item -Path '\\FS-LLN\leerlingen\' -Name $ClassName -ItemType 'Directory'
      }

      # Test if the remote folder exists
      $FolderExists = Test-Path -Path "\\FS-LLN\leerlingen\$ClassName\Opdrachten"
      If (-not $FolderExists)
      {
        # If the opdrachten folder doesn't exist we create it  
        New-Item -Path "\\FS-LLN\leerlingen\$ClassName" -Name 'Opdrachten' -ItemType 'Directory'
      }

      # [ ACL rights for the folder ]
      # Update ACL policy of Opdrachten folder
      $ACLOpdrachten = Get-Acl -Path "\\FS-LLN\leerlingen\$ClassName\Opdrachten"

      # User that gains rights
      $ACLIdentity = "DeHandelsschool\$ClassName"

      # The rights that will be given
      $ACLRights = 'ReadAndExecute'

      # Allow/Deny the ACL rules
      $ACLType = 'Allow'

      # Create the ACL object using the arguments set by the variables
      $ACLArguments = $ACLIdentity, $ACLRights, $ACLType
      $ACLAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $ACLArguments

      # Apply the ACL rule and set it to the \\FS-LLN\$ClassName\Opdrachten folder
      $ACLOpdrachten.SetAccessRule($fileSystemAccessRule)
      Set-Acl -Path "\\FS-LLN\leerlingen\$ClassName\Opdrachten" -AclObject $NewAcl
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
  $Excel = New-Object -ComObject Excel.Application   
  $Workbook = $Excel.Workbooks.Open('\\FS-Personeel\leerkrachten\Gunther Van Bleyenbergh\Leerlingen\lln_ad2019.xlsx')
  $Worksheet = $WorkBook.Sheets.Item(1)

  # Rename the first sheet to 'leerlingen'
  $Worksheet.name = 'leerlingen'

  $ExcelRow = 2

  # Run this in a Try-Catch to not crash the script in case a record isn't found. 
  Try
  {

  }
  Catch [System.Data.OleDb.OleDbException]
  {
    Write-Host 'Cannot find record'
  }

}

