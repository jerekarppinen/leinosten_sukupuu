# Leinoset Heikkistä – Sukupuu

Interaktiivinen sukupuuvisualisointi Leinosen suvulle, joka juontaa juurensa Heikki Leinoseen (s. 1713, Pielisjärvi/Lieksa).

**Live-sivu:** https://jerekarppinen.github.io/leinosten_sukupuu/sukupuu.html

## Sisältö

- `Leinoset Heikkistä.pdf` – alkuperäinen sukupuudokumentti (91 sivua + henkilöhakemisto)
- `sukupuu.html` – itsessään toimiva interaktiivinen visualisointi (ei vaadi palvelinta)

## Visualisoinnin ominaisuudet

- **530 perhettä** ja **2840+ henkilöä** hierarkkisena puuna
- Heikki Leinonen (1713–1796) juurena, haarat laajenevat ~20 sukupolveen asti
- Zoomaus ja panorointi hiirellä / sormella
- Klikkaaminen avaa ja sulkee haaroja
- Oikea klikkaus (tai kosketus) avaa tietopaneelin: syntymä, kuolema, puoliso, lapset
- **Haku nimellä** – löytää sekä perheiden päähenkilöt että lapset joilla ei ole omaa perhettä
  - Hakutulos näyttää perhenumeron (esim. P283) ja vie suoraan oikeaan kohtaan puussa
  - Polku juureen korostuu vihreällä
- Mobiilioptimoitu (kosketusnäyttö, iso hakupalkki, tietopaneeli nousee alhaalta)

## Solmutyypit

| Väri | Merkitys |
|------|----------|
| Sininen (avoin) | Perhe jolla on lapsiperheitä – klikattavissa auki |
| Punainen | Suljettu haara – klikattavissa auki |
| Tumma | Loppusolmu – ei lapsiperheitä |
| Violetti (katkoviiva) | Henkilö jolla ei ole omaa PERHE-numeroa |
| Oranssi | Hakutulos |
| Vihreä | Polku hakutuloksesta juureen |

## Tekninen toteutus

PDF parsittu Pythonilla (`pdfplumber`), joka:
1. Erottaa kaksisarakkeisen sivun erikseen
2. Poimii jokaisen `PERHE`-tietueen: päähenkilö, syntymä/kuolema, puoliso, lapsiviittaukset, lehtilapset
3. Rakentaa hierarkkisen JSON-puun (68 kt → 394 kt kaikkine lapsineen)

Visualisointi tehty D3.js v7:llä (collapsible tree, zoom/pan, haku).
Kaikki data on upotettu suoraan HTML-tiedostoon – ei vaadi erillistä palvelinta tai tietokantaa.

## Suvun lähtökohta

**PERHE 1 – Heikki Leinonen** (s. 1713, k. 4.5.1796 Pielisjärvi Lieksa)  
Puoliso: Anna Myyry (s. 1716, k. 28.4.1776)  
Lapset: Samuel Leinonen (→ P2) ja Juho Leinonen (→ P405)

Suku on kotoisin Pielisjärven (nykyinen Lieksa) alueelta Pohjois-Karjalasta. Dokumentti kattaa noin vuodet 1713–2000-luku.
