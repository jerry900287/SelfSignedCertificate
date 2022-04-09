# SelfSignedCertificate

## Certificate

### EKU
* 開頭為 '1.3.6.1.5.5.7.3.' 為國際標準
* 開頭為 '1.3.6.1.4.1.311.' 為微軟自己設計
* Code Signing '1.3.6.1.5.5.7.3.3'
* Lifetime Signing '1.3.6.1.4.1.311.10.3.13' (有了這個EKU,即便有 Time Stamp 簽署,憑證到期仍會無法使用)

### 年限
* Code Signing Certificate 正常為 1~3 年, 實測後最大值為 3001 年
* 若想要 Code Signing Certificate 不過期, 可以透過 TSA (Time Stamping Server) 蓋上時間戳記,證明此程式是在憑證尚未過期的期間簽署的.

### 時間戳記
在簽章效期內進行蓋章動作時，可以選擇是否要加上時間戳記。想當然爾，當然不會是依據本機時間附加戳記，需要連結 Time Stamping Server 才能附加戳記。一旦正確蓋印上去後，這個檔案的簽署永久有效。不會因為時間超過簽章的有效期而變為無效簽章。

若不附加時間戳記會怎樣？根據上列的兩個目的來看：

沒有附加時間戳，此簽章蓋印的時間無法確定，可能早就被破解了？便也無法確認軟體是不是重新被編譯過，就不具意義了。
Windows 對於沒有時間戳的簽章，會以簽章到期日作為依據。若本機時間在到期日之前，會視為有效簽章，過期便會視為無效簽章。
所以雖然可以自由決定要不要附上時間戳，但依據上述兩個目的來說，顯然是必須的。

### 如何 Code Sign 程式
系統管理員身分執行 'developer Command Prompt for VS 2019',兩種指令:
1. 'signtool sign /tr http://timestamp.digicert.com /td sha256 /f 123.pfx /p "test" /fd SHA384 xxx.exe'
2. 'signtool sign /t http://timestamp.digicert.com/?alg=sha2 /f 123.pxf /p "test" /fd SHA384 xxx.exe'