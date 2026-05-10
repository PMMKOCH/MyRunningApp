# Session-Handoff · 2026-05-10 (evening)

**Vorgänger:** `SESSION-HANDOFF-2026-05-04-night.md`
**Dateistand:** `index.html` — großer Design- und Funktions-Refresh: neue Sport-Themes, Brand-Header, Detail-Sheet, Stats-Strip, Pläne-Tab als Card-Layout mit Progress-Ring, Day-Pace-Override, Notes pro Training, Wochenvolumen-Tracking, 100m-Snap. App-Version `v 2026-05-10-notes-volume`.
**Stimmung am Ende:** User im Flow, jede Welle direkt freigegeben („ja", „das sieht schon richtig gut aus")

---

## Was in dieser Session abgeschlossen wurde

### 1 · Plan-Edit erweitert (Trainingstage änderbar)
- Edit-Modal hat jetzt zwei Pill-Reihen: Multi-Select Trainingstage (Mo–So) + Radio Long-Run-Day
- `savePlanEdit` mappt bestehende Trainings positionsweise auf neue Wochentage, Long-Run-Day greift explizit auf den lang-Day, Rest-Days rutschen auf nicht-gewählte Tage
- Anzahl der Trainingstage muss gleich bleiben (sonst Alert) — Done-Status / Feedback / dayPace bleiben über Index erhalten
- Read-only-Block reduziert auf reine Wochenanzahl-Anzeige

### 2 · Layout-Atmung
- Wochen-Pills nutzen volle Breite via `flex:1 1 auto` mit `min-width:54px`/`max-width:140px` und `flex-wrap:nowrap` + `overflow-x:auto` — bei Platzmangel horizontaler Scroll statt zweite Zeile
- Page-Header rechts-Padding von 152 px auf 20 px reduziert; nur `.page-title` behält 152 px right-padding (für die Topbar-Buttons-Reserve)
- `.page-title` jetzt 28 px, fett, mehr Atmung im Subtitle

### 3 · Klick-Trennung Day-Card + Detail-Sheet
- Klick auf Card-Body → öffnet `openDayDetail(planId, wIdx, dayIdx)` mit großem Sheet
- Klick auf den Häkchen-Kreis → togglet ausschließlich (mit `event.stopPropagation`); Kreis größer (28 px), Cursor-Pointer, Hover-Hint in Grün
- Detail-Sheet mit großer Pace-Tabelle (Schrift 18–22 px) optimiert für die Übertragung aufs Laufband
- Status-Badge oben rechts: HEUTE / VERPASST / ERLEDIGT / GEPLANT
- Aktionsbuttons unten: „Als erledigt markieren" / „Erledigt zurücknehmen" + „Schließen"

### 4 · Verpasste Trainings sichtbar
- Day-Card mit Datum vor heute + nicht erledigt + nicht rest → CSS-Klasse `.missed`: roter Border + roter Hintergrund + VERPASST-Badge im Meta-Block
- Im Detail-Sheet ebenfalls VERPASST-Status

### 5 · Themes komplett neu (Sport-DNA)
- `dunkel` → **Track**: warmes Anthrazit `#0c0d10` + Volt-Lime-Akzent `#b8ff35`
- `hell` → **Sunrise**: Cream `#fff8f1` + Coral `#ff6f3c`
- `all41` raus → **Pacer**: Cool-Grau `#f4f7fb` + Teal `#0891b2`
- Neuer Token `--on-accent` (`#0c0d10` für Track, `#ffffff` für Sunrise/Pacer) sichert Lesbarkeit auf Akzent-Buttons; alle `color:#fff`-Stellen auf Akzent-BG umgestellt
- Theme-Migration in Init: alte localStorage-User mit `all41` → `pacer`
- Status-Bar-Color (iOS) angepasst

### 6 · 100m-Snap auf Distanzen
- `parsePaceLine.formatDist` rundet jede Distanz auf 100 m und gibt `{label, km}` zurück; `timeSec` aus geglätteter Distanz neu berechnet → Anzeige und Laufband-Eingabe identisch
- `renderLangTable` parst die `lang.p1/p2/p3.km`-Strings, snappt auf 100 m, formatiert konsistent
- KI-Prompt: neue Pflichtregel #10 in `COACH_HARD_RULES` — alle Distanzen müssen in 100-m-Schritten sein, krumme Werte runden

### 7 · Brand-Header oben
- `.brand-bar` fixed top, 54 px hoch, mit Logo (J-Kurven-SVG in Akzentfarbe) + Wortmarke „LAUF**PLAN**" + 3 Action-Icons (Reload · Theme · Hilfe)
- Alte fixed `.theme-btn`/`.reload-btn`/`.help-btn` versteckt (`display:none`) und durch `.brand-btn`-Variante in der Bar ersetzt
- Page-Header rückt unter die Brand-Bar (sticky `top:54px`)

### 8 · Stats-Strip im Tracker
- 3 Kacheln direkt unter dem Plan-Header: **Streak** (Flame-Icon, abgeschlossene Trainings in Folge), **Diese Woche** (TrendingUp, gelaufen / geplant in km), **Bis Ziel** (Target, Tage)
- Streak-Logik: bricht bei verpasstem Training, bricht NICHT bei Heute oder Zukunft
- Stats werden via `calcPlanStats(plan)` zentral berechnet und auch im Pläne-Tab wiederverwendet

### 9 · Day-Cards mit Workout-Type-DNA
- `TYPE_ICON`-Map: intervall→zap, tempo→flame, easy→wind, lang→mountain, strides→activity, rest→moon
- Border-left in Type-Farbe (`--type-color`): Lila / Amber / Grün / Akzent / Coral / Faint
- Type-Icon im Meta-Block direkt vor dem Wochentag (in Type-Farbe)
- Status-Pille rechts in der Meta-Zeile: HEUTE / VERPASST / ERLEDIGT
- Mehr Atmung: `padding:14px 16px`, `gap:10px` zwischen Cards

### 10 · HEUTE-Card als Hero
- Box-Shadow als Glow in Akzent-Soft, leichter `translateY(-1px)`, Akzent-Border, Hintergrund-Gradient im day-main
- Title 18 px statt 14 px

### 11 · Pläne-Tab überholt (Sport-Card-Layout)
- Plan-Liste rendert `.plan-card` mit Progress-Ring (62 px, SVG-stroke-dasharray) — innen `pct%` + `done/total`
- Stats-Strip pro Plan: Ziel-km · Streak · Bis Ziel · Coach-Score (klickbar öffnet Coach-Review)
- Active-Card mit 2 px Akzent-Border + Glow-Schatten — klar als „der Plan, der läuft"

### 12 · Auto-Scroll zu HEUTE
- `jumpToTodayWeek(plan)` setzt `state.currentWeek` automatisch auf die Woche, in der heute liegt
- `scrollTrackerToToday()` scrollt nach `setTimeout(90)` die `.day-card.today` zentriert ins Sichtfeld
- Triggert in `showScreen('tracker')` und damit auch beim App-Start

### 13 · Tempo-Steuerung 1 %-Schritte
- `adjustPace`-Aufrufe von `0.05` auf `0.01` umgestellt (Plan-globaler Tempo-Slider)

### 14 · Day-Pace-Override (pro Training)
- Neuer State `state.dayPace[key]`; Helper `dayPaceFactor / setDayPaceFactor / adjustDayPace / resetDayPace`
- `dpf`-Bestimmung in Day-Card: erledigt → eingefroren · sonst dayPace-Override (falls gesetzt) · sonst Plan-Faktor
- Override-Badge in der Day-Card-Meta („+3 %", Akzentfarbe), Tempo-Adjuster-Block im Detail-Sheet mit ±-Buttons (1 %), Reset-Button „⟲ Plan"
- `toggleDone` friert beim Abhaken den effektiven Faktor ein (Override-Vorrang vor Plan-Faktor)

### 15 · Notiz pro Training (optional)
- `state.notes[key]` als Freitext, `setDayNote(planId, wIdx, dayIdx, text)` speichert auf `oninput`
- Textarea unten im Detail-Sheet mit Placeholder-Beispielen, klar als optional gekennzeichnet
- `adaptPlanFromFeedback`: Notizen werden pro Feedback-Eintrag mitgegeben; bei vorhandenen Notizen kommt zusätzlicher Prompt-Block, der die KI explizit anweist, Beschwerden / externe Faktoren / präzise Wahrnehmung in die Plan-Anpassung einzubeziehen

### 16 · Wochenvolumen-Tracking
- Helpers: `dayKm(day, plan)` summiert km aus `paces[]` (mit Wiederholungen, ohne Pausen) und `lang.p1/p2/p3.km`; `weekKm(plan, wIdx)` und `weekKmDone(plan, wIdx)`; `fmtKm(km)`
- Stats-Strip „Diese Woche" zeigt jetzt `8,5 / 17 km` statt `2 / 4`
- Wochen-Pills mit Sub-Label `XX,X km` — Steigerungs-Kurve und Tapering-Drop visuell sichtbar
- CSS-Anpassung: `.week-tab` als Spalten-Layout (Wochentitel + km-Zahl), `.week-tab-num` und `.week-tab-km` styled
- Cleanup von `dayPace` und `notes` in `resetWeek` und `deletePlan`

### 17 · Hosting-Beratung (kein Code)
- User hatte GitHub-Repo auf privat gestellt → GitHub Pages bricht; Empfehlung Netlify Drop für privat + 2-Min-Deploy

---

## Was als Nächstes ansteht

### Hauptauftrag (offen)
- **Realtest am Laufband** mit dem neuen Theme/Stats/100m-Snap — User soll prüfen ob die Pace-Tabelle in Detail-Sheet-Großschrift gut lesbar ist und ob die km-Werte am Laufband 1:1 passen

### Konkrete Cherry-Picks (offen)
- **Bottom-Tabs** aufwerten: Active-Pill-Indicator, größere Icons, animierter Strich — aktuell schlicht ohne klaren Active-Style außer Color-Wechsel
- **Microinteractions beim Abhaken**: Checkmark-Pop-Animation, evtl. Konfetti bei Streak-Milestones (z. B. 5/10/20 in Folge)
- **Coach-Banner-Schrittweite anpassen**: `coachSuggest`/`Banner-Texte` arbeiten in `0.05`-Sprüngen (5 %); jetzt wo der manuelle Slider 1 % macht, könnte Coach auch feiner vorschlagen (z. B. 2 % bei einzelnen `easy`/`hard`, 5 % nur bei klarem Trend)
- **Empty-State Tracker** wenn kein Plan aktiv: aktuell zeigt der Tracker bei `!activePlanId` einen leeren Block, könnte motivierend gestaltet werden mit „Aktiviere einen Plan" + großem Button
- **Recovery-Indicator**: 2+ Hard-Tage hintereinander → roter Hinweis im Stats-Strip oder als Coach-Banner („heute lieber easy"). Methodisch wertvoll, hängt an Notes/Feedback-Auswertung
- **Plan-Export als JSON für Mac↔iPhone-Sync** (bekanntes Cherry-Pick aus letztem Handoff, weiterhin offen)
- **Zieldistanz im Edit-Modal editierbar** (bekannt, weiterhin offen)
- **PNG-Versionen vom Logo** (aus letztem Handoff, weiterhin offen)

### Nicht angefasst (parkiert)
- HR-Zonen / Pulszonen-Training
- GPS / Run-Logger
- Push-Notifications
- Schuh-Tracking / Wettertracking
- Plan-Verlauf-History (mehrere Coach-Reviews je Plan)

---

## Code-Einstiegspunkte (aktueller Stand)

| Bereich | Funktion / Stelle | Inhalt |
|---|---|---|
| Themes (Tokens) | `:root` / `body[data-theme="hell"]` / `body[data-theme="pacer"]` | Track / Sunrise / Pacer mit `--on-accent` für Akzent-Text-Lesbarkeit |
| Themes (Liste) | `THEMES`-Array + `applyTheme(id)` | id `dunkel` (Track) · `hell` (Sunrise) · `pacer`; Migration `all41` → `pacer` in Init |
| Brand-Header | `.brand-bar` + Markup unter `<body>` | Logo + Wortmarke + 3 Action-Icons; alte `.theme-btn`/`.reload-btn`/`.help-btn` versteckt |
| Page-Header | `.page-header` + `.screen` | sticky `top:54px`, 28 px Title, `padding-top:54px` für screens |
| Stats-Strip (CSS) | `.stats-strip` / `.stat-card` / `.stat-val` | 3-Kachel-Layout mit Mono-Zahlen |
| Stats-Berechnung | `calcPlanStats(plan)` | Streak / wkDone / wkTotal / daysToEnd |
| Wochenvolumen | `dayKm(day,plan)` · `weekKm(plan,wIdx)` · `weekKmDone(plan,wIdx)` · `fmtKm(km)` | km aus paces[] (ohne Pausen) und lang.p1/p2/p3 |
| Type-Icons | `TYPE_ICON`-Map + neue ICONS (`wind`, `mountain`, `moon`, `calendar`) | intervall→zap, tempo→flame, easy→wind, lang→mountain, rest→moon |
| Day-Cards (CSS) | `.day-card.t-{type}` + `--type-color` | Border-left in Type-Farbe; HEUTE-Card mit Glow + Translate; `.missed` rot |
| Day-Cards (Render) | renderTracker `dayCards` | Type-Icon im Meta-Block, Override-Badge, Status-Pille |
| Wochen-Pills | `.week-tab` / `.week-tab-num` / `.week-tab-km` + Render-Loop in `renderTracker` | Spalten-Layout mit km-Sub-Label, horizontaler Scroll bei Platzmangel |
| Detail-Sheet (CSS) | `.detail-sheet` + Override pace-table-Größen | Großschrift für Laufband-Übertragung |
| Detail-Sheet (Markup) | `<div id="day-detail-bg">` unter `<body>` | Sheet-Pattern wie Theme-Sheet |
| Detail-Sheet (Render) | `openDayDetail(planId,wIdx,dayIdx)` / `closeDayDetail()` | inkl. dpf-Bestimmung mit Day-Override, Tempo-Adjuster-Block, Notes-Textarea |
| Klick-Trennung | renderTracker Day-Card-Markup | `day-main onclick=openDayDetail` + `check onclick=event.stopPropagation;toggleDone` |
| Day-Pace-Override | `dayPaceFactor` · `setDayPaceFactor` · `adjustDayPace` · `resetDayPace` | `state.dayPace[key]`; eingefroren bei toggleDone (Override-Vorrang) |
| Notes pro Training | `setDayNote(planId,wIdx,dayIdx,text)` | `state.notes[key]`; Textarea im Detail-Sheet mit `oninput` |
| Notes im Adapt-Prompt | `adaptPlanFromFeedback(plan, btnEl)` | Notizen pro Feedback-Eintrag; `notesHint`-Block bei vorhandenen Notes |
| Trainingstage editierbar | `openPlanEdit(id)` Pill-Multi-Select / `savePlanEdit()` Mapping-Block | Trainings position-mapping, Long-Run-Day-Override, Rest-Day-Verteilung |
| 100m-Snap (Pace) | `parsePaceLine` `formatDist`-Helper | Snapped Distanz + recomputed timeSec |
| 100m-Snap (Lang) | `renderLangTable` `snap100`/`fmtKm`/`parseKm` | gleiche Logik in Phasen-Berechnung |
| KI-100m-Regel | `COACH_HARD_RULES` Punkt 10 | Pflichtregel für Plan-Generator und Reviewer |
| Auto-Scroll HEUTE | `jumpToTodayWeek(plan)` + `scrollTrackerToToday()` + `showScreen('tracker')`-Hook | Smart-Week-Switch + scrollIntoView |
| Pläne-Tab (Card) | `renderPlans()` mit `.plan-card`/`.plan-ring`/`.plan-card-stats` | Progress-Ring (SVG) + Stats-Strip pro Plan |
| Tempo 1 % | renderTracker pace-card-Buttons | `adjustPace(planId,±0.01)` statt `±0.05` |
| Cleanups | `resetWeek` / `deletePlan` | dayPace + notes werden mit gelöscht |

---

## Memory-Stand

- Keine neuen Memories in dieser Session angelegt — User-Profil und Project-Memories aus Vorgänger-Sessions weiterhin gültig

---

## Start-Prompt für nächste Session

```
Lies Laufplan App/SESSION-HANDOFF-2026-05-10-evening.md.

Kurz-Status: Komplett-Refresh durch. App jetzt mit Sport-Themes (Track/Sunrise/Pacer),
Brand-Header, Stats-Strip mit Streak/km/Bis-Ziel, Day-Cards mit Type-Icons +
HEUTE-Hero, Pläne-Tab mit Progress-Ring, Detail-Sheet beim Tap auf Card mit
Großschrift für Laufband, Day-Pace-Override pro Training, optionale Notizen die
in den Adaptive-Coach fließen, Wochenvolumen statt Trainings-Anzahl, 100m-Snap
auf allen Distanzen. App-Version v 2026-05-10-notes-volume.

Heute: <eintragen — Optionen: Bottom-Tabs aufwerten (Active-Pill), Microinteractions
beim Abhaken, Coach-Banner-Schrittweite an 1%-Slider anpassen, Recovery-Indicator,
Empty-State Tracker, Plan-Export JSON für Mac↔iPhone-Sync, oder anderes Thema>
```

---

**Pfad des Handoffs:** [Laufplan App/SESSION-HANDOFF-2026-05-10-evening.md](Laufplan%20App/SESSION-HANDOFF-2026-05-10-evening.md)
