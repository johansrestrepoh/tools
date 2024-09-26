# Ruta del archivo CSV con la lista de aplicaciones a eliminar
$csvPath = ".\AppxPackages.csv"

# Lee el archivo CSV (Se asume que el CSV tiene una columna llamada 'AppName' con los nombres de los paquetes)
$appsToRemove = Import-Csv -Path $csvPath

# Lista de aplicaciones a excluir
$excludeApps = @(
    "Microsoft.StorePurchaseApp",
    "Microsoft.WindowsCalculator",
    "Microsoft.Windows.Photos"
)

# Función para remover aplicaciones
function Remove-AppxPackageByName {
    param (
        [string]$appName
    )

    # Obtiene el paquete por nombre
    $appPackage = Get-AppxPackage | Where-Object { $_.Name -eq $appName }
    
    if ($appPackage) {
        Write-Host "Removiendo: $($appPackage.Name)"
        Remove-AppxPackage -Package $appPackage.PackageFullName
    } else {
        Write-Host "No se encontró el paquete: $appName"
    }
}

# Itera a través de las aplicaciones del CSV y elimina si no está en la lista de exclusión
foreach ($app in $appsToRemove) {
    $appName = $app.AppName

    if ($excludeApps -contains $appName) {
        Write-Host "Excluyendo: $appName"
    } else {
        Remove-AppxPackageByName -appName $appName
    }
}

Write-Host "Proceso completado."
