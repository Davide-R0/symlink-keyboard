# Keyboard

## Tools

- Build123d: for the viewer look [external editors](https://build123d.readthedocs.io/en/latest/external.html#external), in general we use: `yet-another-cad-viewer` (c'è una estensione per nvim o vscode?)
- SKiDL: to convert form kicad use tool: `netlist_to_skidl` (TODO: setup kicad liberary for this)
- Openscad to build123 migration: [look here](https://build123d.readthedocs.io/en/latest/OpenSCAD.html)
- for the pcb routing still use kicad editor

## General proprieties

- Layout `4x6+5`
- Parte sinistra il master, destro slave
- Si pososno caricare due firmwere diversi:
  - Bluetooth tra le due parti, se collegato il cavo intermedio e collegato il master al pc si caricano entrambe le schede. In entrambi i casi si può o collegare col cavo al pc per avere cablato il master o col bluetooth col master.
  - Cablato tra le due parti, in questo caso bisogna collegare il cavo tra le due parti e poi si può decidere se collegarla al pc tramite bluetooth o cavo con il master.
- led rgb per key e anche sul retro (led sotto tasti e sul retro sono in due lineee dati separati perchè quando va con batteria funzionano solo quelli sul retro, quando colelgato via cavo funzionano entrambi)
- schermo oled e potenziometro per lato
- Case "Sandwich Mount"
- Framework: `ZMK`, si possono creare moduli in C, supporta BLE e il nice!nano v2.
- Round trackpad (Circle Touchpad), mini touchpad. Il `TM023023-2024` su `Mouser` (c'è sia con overlay che senza, si può usare un nastro personalizzato se si vuole: ) per il connettore: connettore FPC 12-pin, 0.5mm pitch, bottom contact (52746-1271 ?). Altrimenti già completo (ma grande): [splitkb](https://splitkb.com/products/halcyon-cirque-touchpad-module?_pos=1&_sid=2299becd1&_ss=r). NOTA: forse ci sta anche al verisone da 35mm di diametro)

## Components

- Un micorcontroller `nice!nano v2` per lato (Pro Micro NRF52840) (Amazon o Aliexpress)
- Una batteria per lato sotto il microcontroller: `303040`, per la batteria forse fare un dopio fondo (cioè tagliare la back pcb e metterne un'altra che sporge di più sul retro così da poter mettere batterie più spesse (503040 o 503050)) (Aliexpress)
NOTE: le batterie anderebbero sempre circa 400-500mA (`403040`) a destra e 700-800mA (`403050`) a sinistra per consumo giusto.
- Un pannello oled per lato `0.91 inch OLED LCD Display IIC 128×32` (Amazon o Aliexpress)
- Un potenziometro a sinistra: `EC11` con click (LCSC)
- Un Circle Touchpad a destra: [splitkb](https://splitkb.com/products/halcyon-cirque-touchpad-module?_pos=1&_sid=2299becd1&_ss=r). Per la connesisone c'è bisogno di:
  - FPC a 12 pin: `FPC-05F-6PH20` (LCSC) (NOTE: è difficile da saldare? se dovesse essere cercare i "FPC to DIP breakout 12 pin 0.5mm")
  - Per il trackpad c'è un problema: macano i pin, bisogna usare un io expander: `PCA9536D` (4 pin extra) (LCSC)
- I switch `Kailh Choc V2 'Deep Sea' Brown` (tattili, low profile, silenziosi, con alloggio a croce) (Aliexpress)
- Socket per i switch `Kailh Choc Low Profile Socket` compatibili con choc. (Aliexpress) TODO: rivedere socket compatibili!
- Led rgb `SK6812MINI-E` per switch (trought hole) (LCSC)
- Led RGB `SK6812-5050` per la retorilluminazione (x6 per lato) (LCSC)a
- Per i led rgb di va un circuito che scollega l'alimentazione se non servonoe:
  - -- Transistor P-CH mosfet: `AO3401A` SOT-23 (LCSC)
  - -- Transistor N-CH mosfet: `AO3400A` SOT-23 (LCSC)
  - -- Resistena 100kohm: `ERJ6ENF1003V` 0805, per il pull-down per il P-CH (LCSC)
  - -- Resistena 10kohm: `TE05H1002BT` 0805, per il pull-up per il N-CH (LCSC)
  - Al posto dei mosfet grandi e resistenze meglio come: `TPS22917` + condensatore da 1nF: `CL21C102JBCNNNC` (LCSC)
- Resistenze 4.7kohm: `ERJU6RD4701V` 0805, per pullup per SDA e SCL (LCSC)
- Resistenza 400ohm: `TR0805B400RP0525Z` 0805, per l'ingresso DIN dei led (potrebbero esserci sovralimentazioni) (LCSC)
- Diodi: `1N4148W-E3-08` in SOD-123 per i led (cambiare il formato per facilità di saldatura?) (LCSC)
- Connection between split:
  - usb-c ports x2: `TYPE-C 16PIN 2MD`, per connessione tra due parti (LCSC)
  - ESD protection (Chip TVS): `USBLC6-2SC6`
  - PTC fuse (6V 1.5-2A): `1206L150/6V` (NOTE: forse meglio da 2A `1206L200/6V`) (LCSC)
  - Filtro RC per lo shield del usb-c: resistenza: (1kOhm) `RC0805FR-071KL`, condensatore (100nF 100V X7R) `CC0805X7R100V104MN`
  - Resistenza (5.1kohm): `0805W8F5101T5E`, per le connessioni pull-down CC1 CC2 (per alimentaizone)
  - Resistenza (22kohm) con supporto da 1.5A: `ERJ6ENF2202V`, per le connessioni pull-up CC1 CC2 (per alimentaizone)
  - Ideal Diode IC: `MAX40200AUK+T`, per il ritorno di corrente dalla porta (LCSC)
  - --Load switch IO (per protezione da correnti inverse): `TPS22918`
  - -- Diodi Zener da 3.3V: `BZT52C3V3-E3-18`, per protezione da collegamento scorretto (SOD-123) (LCSC)
  - -- resistenze: `0805W8F1000T5E`, 100 ohm 0805 per protezione da collegamento scorretto (LCSC)
- headers low profile: `Mill-Max Mfg. Corp. 315-43-112-41-003000`, to connect the nice!nano to the main pcb (and also the oled display) (LCSC) (OLD: header female connectors: `PM2.54-1X8PM-H85` (o altre versioni...))
- brass spacers M2 (+ viti): `Kit distanziatore in ottone` (Aliexpress)
- slider switch SMD : `PCM12SMTR`, per accendere/spegnere la batteria per ogni lato (LCSC)
- button SMD: verticale: `TL3342F450QG` oppure laterale: `SKSCLDE010`, per mettere la scheda in modalità bootloader. (LCSC)
- PCBs: "Sandwich Mount":
  - Layout:
    - Top Plate: dove voengono incastrati i switch
    - Main PCB: dove c'è tuta la elettornica
    - Bottom Plate: per proteggere la eletronica deall'esterno.
  - Il tutto connesso isnieme con viti M.2 e distanziali in ottone:
    - Tra il main pcb e il Top plate non is mettono distanziali perchè sono gli switch a tenere il palte.
    - Tra main pcb e botton plate: distanziali tra `6-8mm`.
  - Per la pendenza o si mettono distanziali assimmetrici,oppure si usa il `Tenting Puck`, (JLCPCB)
- Livellatore di tensione (Level Shifter): `SN74LVC1T45DBVR` per la linea dati dei led (LCSC)
- Per prioteggere sovratensioni TX/RX un Logic Buffer: `SN74LVC2G34DBVR` (LCSC)
- --Diodo Schottky: `SS14`, per il ritorno della batteria quando sono collegati tramite filo le due parti (LCSC)
- Kampton tape: per l'isolamento e resistenza al calore (Aliexpress)
- Pasta saldante: per componenti smd (Aliexpress)


Switch Kailh Choc V2: Ottimi, ma ricorda che hanno un'altezza diversa dai V1. Il tuo "Top Plate" deve avere uno spessore di $1.2\text{ mm}$ o $1.5\text{ mm}$ (taglio laser o PCB) per permettere agli switch di "cliccare" correttamente in posizione.

NOTE: per i componenti smd i formati da scegliere sono:

- SOT-23 per i chip a più gambe
- 0805 per R, C e componenti a 2 gambe

QT_QPA_PLATFORM=xcb freecad
