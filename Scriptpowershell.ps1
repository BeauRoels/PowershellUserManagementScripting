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
      $GroupName = $ClassRecord.klas

      # Creating the container
      New-ADGroup -Name $GroupName -SamAccountName $GroupName -GroupCategory Security -GroupScope Global -DisplayName $GroupName -Path 'OU=leerlingen,DC=Handelsschoolaalst,DC=be' -Description "Leerlingen in deze groep maken deel uit van klas $ClassName"    }
  }
  Catch [System.Data.OleDb.OleDbException]
  {
    Write-Host 'Cannot find record'
  }
}
