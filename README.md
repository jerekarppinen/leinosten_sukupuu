# Leinoset Heikkistä – Sukupuu

Interaktiivinen sukupuuvisualisointi Leinosen suvulle, joka juontaa juurensa Heikki Leinoseen (s. 1713, Pielisjärvi/Lieksa).

**Live-sivu:** https://jerekarppinen.github.io/leinosten_sukupuu/sukupuu.html

## Ominaisuudet

- 530 perhettä ja 1853 henkilöä hierarkkisena puuna
- Heikki Leinonen (1713–1796) juurena, haarat laajenevat ~20 sukupolveen
- Zoomaus ja panorointi hiirellä tai sormella
- Klikkaaminen avaa ja sulkee haaroja
- Oikea klikkaus tai kosketus avaa tietopaneelin: syntymä, kuolema, puoliso
- Haku nimellä — löytää sekä PERHE-päähenkilöt että lehtilapset. Polku juureen korostuu vihreällä.
- Mobiilioptimoitu: iso hakupalkki, tietopaneeli nousee alhaalta

## Solmutyypit

| Väri | Merkitys |
|------|----------|
| Sininen | Perhe jolla on lapsiperheitä – klikattavissa auki |
| Punainen | Suljettu haara – klikattavissa auki |
| Tumma | Loppusolmu – ei lapsiperheitä |
| Violetti (katkoviiva) | Henkilö jolla ei ole omaa PERHE-numeroa |
| Oranssi | Hakutulos |
| Vihreä | Polku hakutuloksesta juureen |

## Suvun lähtökohta

**PERHE 1 – Heikki Leinonen** (s. 1713, k. 4.5.1796 Pielisjärvi/Lieksa)  
Puoliso: Anna Myyry (s. 1716, k. 28.4.1776)  
Suku on kotoisin Pielisjärven (nykyinen Lieksa) alueelta Pohjois-Karjalasta. Dokumentti kattaa noin vuodet 1713–2000-luku.

---

## TECH NOTES

### Arkkitehtuuri

`sukupuu.html` on täysin itsessään toimiva — ei palvelinta, ei erillistä dataa. D3.js v7 ladataan Cloudflare CDN:stä. Kaikki puudata on upotettu muuttujaan `const RAW_DATA = {...}` suoraan HTML:n `<script>`-tagiin.

HTML generoidaan Python-skriptillä Cowork-sandboxissa (ei versioitua skriptiä repossa — aja tarvittaessa uusi sessio ja rekonstruoi alla olevan kuvauksen perusteella).

### PDF-parsinta

PDF on kaksisarakkeinen → jokainen sivu croppataan `pdfplumber`-kirjastolla puolivälissä ja sarakkeet parsitaan erikseen. Teksti yhdistetään ja splitataan PERHE-tietueisiin:

```python
blocks = re.split(r'(?=PERHE \d+\b)', all_text)
```

Jokainen PERHE-tietue sisältää: päähenkilö + syntymä/kuolema, puoliso, lapsiviittaukset (`Perhe X.`), ja Lapset-osio.

### Lehtilapsiparser — kriittisin kohta

Lapset-osiossa listataan kaikki lapset. Osalla on oma PERHE-numero (→ sininen solmu puussa), osalla ei (→ violetti lehtisolmu). Parserin tärkein haaste:

**"Perhe X." on usein omalla rivillään paikanimen kanssa:**
```
Mervi Kristina Leinonen, s. 13.5.1956
Lieksa. Perhe 282.
```

Tämän takia rivejä **ei voi splitata isolla alkukirjaimella** erikseen — "Lieksa" saisi oman splitin ja "Perhe 282" irtoaisi nimestä, jolloin Mervi päätyisi virheellisesti lehtilapsaksi vaikka hänellä on oma perhe.

Ratkaisu: rivit **ryhmitellään henkilöittäin** `is_name_line()`-funktiolla. Uusi henkilö alkaa vain kun rivi on muotoa "Etunimi Sukunimi" (kaksi isolla alkavaa sanaa). Näin "Lieksa. Perhe 282." pysyy samassa ryhmässä Mervin kanssa.

Lisäksi suodatetaan pois: paikannimet, muuttoilmoitukset, vanhempiviittaukset, lyhyet fragmentit. "poika/tytär Sukunimi" -tyyppiset nimetöntä lasta tarkoittavat merkinnät hyväksytään ja kapitalisoidaan.

**Sanity-check uuden generoinnin jälkeen:**
- P281 leaf_children == [] (Mervi/Jaana/Marjo eivät saa olla lehtilapsina — heillä on omat P282/283/284)
- P2 leaf_children sisältää "Poika Leinonen"
- P283 leaf_children sisältää "Jere Ville Valtteri Karppinen"

### D3-puu

- `allNodes = root.descendants()` rakennetaan **ennen** syvyyden sulkemista, jotta haku löytää kaikki
- Hakutulosklikkaus tallentaa suoran node-referenssin (`visibleMatches[idx]`), ei UID-hakua — suljetuilla solmuilla ei ole UID:tä ennen renderöintiä
- `fitView()` ajetaan `requestAnimationFrame`:lla, koska SVG:n mitat ovat 0 ennen DOM-renderöintiä
- Mobiili: `@media (pointer: coarse)` (ei px-leveys, koska tabletti voi olla leveä)
- Hakutulosten positiointi: `getBoundingClientRect()` dynaamisesti, ei kovakoodattu `top`-arvo

### HTML-tiedoston rakenne

```
<head> + <style>          ~6 800 merkkiä
const RAW_DATA = {...}   ~255 000 merkkiä (puudata)
D3-koodi                  ~16 000 merkkiä
</script></body></html>
```

Jos tiedosto katkeaa (write-ongelma), se katkeaa yleensä D3-koodin loppupuolella. Tunnistaa siitä että `</html>` puuttuu tai tiedosto loppuu kesken lauseen. Korjaus: lisää puuttuva häntä takaisin.

### Git-workflow

```powershell
cd C:\Users\jerek\Documents\leinoset_sukupuu
git add sukupuu.html README.md
git commit -m "Viesti"
git push
# GitHub Pages päivittyy automaattisesti ~1 min kuluessa
```

Git ei toimi Cowork-sandboxista Windows-mountin config-ongelman takia — push pitää aina tehdä käyttäjän omassa PowerShellissä.
