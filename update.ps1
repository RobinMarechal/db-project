function Expand-ZIPFile($file, $destination)
{
$shell = new-object -com shell.application
$zip = $shell.NameSpace($file)
foreach($item in $zip.items())
{
$shell.Namespace($destination).copyhere($item)
}
}

$DOCDIR = (Get-Item -Path ".\" -Verbose).FullName
(New-Object Net.WebClient).DownloadFile('https://github.com/prafiny/db-project/archive/master.zip',"$DOCDIR\master.zip");
Expand-ZIPFile -File "$DOCDIR\master.zip" -Destination "$DOCDIR\"; Remove-Item "$DOCDIR\master.zip";

$myArray = autoload.php,composer.json,composer-setup.php,controller,instructions,lib,README.md,tests,update.sh,view,www,update.ps1
foreach($item in $myArray)
{
Remove-Item -path $DOCDIR\$item -recurse
$shell.Namespace($DOCDIR\).copyhere(db-project-master\$item)
}
