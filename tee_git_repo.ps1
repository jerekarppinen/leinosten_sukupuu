Set-Location -Path $PSScriptRoot

git config --global user.name "Jere Karppinen"
git config --global user.email "jere.karppinen88@gmail.com"
git config --global init.defaultBranch main

git init
git add .
git commit -m "Alkuperäinen sukupuu: Leinoset Heikkistä (530 perhettä)"

Write-Host ""
Write-Host "Git-repositorio luotu!" -ForegroundColor Green
Write-Host ""
Write-Host "Seuraavat vaiheet GitHub Pagesiin:" -ForegroundColor Cyan
Write-Host "  1. Luo uusi repo osoitteessa: https://github.com/new"
Write-Host "  2. Nimeä se esim. 'sukupuu'"
Write-Host "  3. Kopioi remote-osoite ja aja:"
Write-Host "       git remote add origin https://github.com/KÄYTTÄJÄNIMI/sukupuu.git"
Write-Host "       git push -u origin main"
Write-Host "  4. GitHub: Settings → Pages → Branch: main → Save"
Write-Host "  5. Osoite: https://KÄYTTÄJÄNIMI.github.io/sukupuu/sukupuu.html"
Write-Host ""
Read-Host "Paina Enter sulkeaksesi"
