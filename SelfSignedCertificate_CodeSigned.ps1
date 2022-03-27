# Certificate Name
$subject = "CN=CodeSignServices,O=USD"
# Hash Algorithm
$hashAlgorithm = "SHA384"
#KeyUsage
$keyUsage = "KeyEncipherment"
#EKU
$EKU = @("2.5.29.37={text}1.3.6.1.5.5.7.3.3,1.3.6.1.4.1.311.10.3.13")
#KeyAlgorithm
$keyAlgorithm = "RSA"
#KetSize
$keyLength="2048"
#Period
$period = "7000"
$provider = "Microsoft Software Key Storage Provider" 
#Microsoft Software Key Storage Provider
#Microsoft Platform Crypto Provider

$path = "Cert:\CurrentUser\My"

#Certificate Issue
$cert = New-SelfSignedCertificate -Type Custom `
-Subject $subject `
-CertStoreLocation $path `
-TextExtension $EKU `
-KeyUsage $keyUsage `
-HashAlgorithm $hashAlgorithm `
-KeyAlgorithm $keyAlgorithm `
-KeyLength $keyLength `
-Provider $provider `
-NotAfter (Get-Date).AddYears($period) 
#-NotAfter (GetDate).AddHours($period)
#-NotAfter (GetDate).AddDays($period)

#When using exportaable CSP
if($provider.Equals("Microsoft Software Key Storage Provider")){
    $cert.Thumbprint
    while(1){
        $inputF = Read-Host "Input the password for PFX file" -AsSecureString
        $inputS = Read-Host "Confirm the password" -AsSecureString
        $passwordF = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($inputF))
        $passwordS = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($inputS))
        if($passwordF.Equals($passwordS)){
            Write-Host "Password Correct!"
            break
        }
        else{
            Write-Host "The password is not the same, please input again."
        }
    }
    $pass = ConvertTo-SecureString -String $passwordF -Force -AsplainText
    #Export to PFX
    $cert | Export-PfxCertificate -FilePath WDSCert.pfx -Password $pass
    #Export to Cert
    $cert | Export-Certificate -FilePath WDSCert.cer
    #Remove local certificate
    $cert | Remove-Item
}