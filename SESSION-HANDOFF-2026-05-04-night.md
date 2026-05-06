# Session-Handoff · 2026-05-04 (night)

**Vorgänger:** `SESSION-HANDOFF-2026-05-03-1252.md`
**Dateistand:** `laufplan_app.html` — komplett überarbeitet (~3000+ Zeilen). Neue Funktionen: Coach-Review-Loop mit KI, Plan-Versionierung, Adaptive Anpassung, Laufband-Tabelle, Datums-Header, Steigung, Strides-Logik. App-Version `v 2026-05-04-18:40`.
**Stimmung am Ende:** „jetzt passt es"

---

## Was in dieser Session abgeschlossen wurde

### 1 · Datums-System & Plan-Range
- Plan bekommt `startDate` (snappt auf Mo)
- Tag-Datum in Badges (`Mo · 04.05.`)
- Plan-Range im Tracker-Header (`04.05. – 14.06.2026 · 6 Wochen`)
- Wochen-Range im Wochen-Header
- „Heute"-Erkennung über echtes Datum statt Wochentag
- Ensure-Migration setzt fehlende Felder bei Bestands-Plänen

### 2 · Topbar mit drei Icons
- Reload-Button (Pfeil-Icon) — leert SW-Cache + Reload
- Theme-Button (Kreis-Icon)
- Help-Button (Frage-Icon) → öffnet Hilfe-Sheet mit iPhone-Setup-Anleitung
- Header-Padding 152 px rechts reserviert für die drei Buttons

### 3 · Brand-Tokens & Style-Guide-Look
- Brand-Tokens vereinheitlicht (`--afo-orange-600`, `--afo-purple-dark` etc.)
- Spacing-Skala `--sp-1` bis `--sp-7`
- Status-Farben (`--c-ok`, `--c-warn`, `--c-danger`)
- Theme „all41" komplett neu (Light, Lila/Orange wie Portfolio-APP-Style-Guide)
- Custom-Logo `icon.svg` (J-Kurve mit Peak-Zielpunkt + 3 Stride-Markierungen)

### 4 · Lucide-Icons (alle Emojis raus)
- Tab-Icons (activity / list / sparkles)
- Reset-Buttons (rotateCcw)
- Kinomap (play)
- Feedback-Pills (coffee / check / flame)
- Plan-Aktionen (power / edit / trash)
- Erfolgs-Modals (check groß)
- Empty-States (activity / list groß)

### 5 · Pace & Tempo-System
- Pace-Card mit Ziel-Anzeige (Distanz · Zeit · min/km)
- Tempo-Slider (±5 % Schritte)
- Tempo-Reset-Button
- **Bake-In** („als Standard übernehmen") — schreibt aktuellen Faktor fest in alle Pace-Strings
- Pace per km min/km Anzeige neben km/h
- Plan-Steigung in jeder Pace-Chip (`↗ 1 %`)
- Sprint-Tempo separat einstellbar
- Hill-Training optional (KI-flag)
- Warm-up/Cool-down konfigurierbar (Default 400/400)

### 6 · Coach-Agent & Review-Loop
- Agent `coach-running.md` in `~/.claude/agents/` angelegt (für künftige Sessions verfügbar)
- `COACH_PERSONA_INTRO` + `COACH_HARD_RULES` als zentrale Konstanten — Single-Source-of-Truth
- Generator UND Reviewer nutzen dieselbe Methodik (Daniels VDOT, Seiler 80/20, Lydiard, ACSM)
- Reviewer-Prompt geschärft: User-Eingaben sind FIX, nicht zu hinterfragen
- Generator-Prompt strikt: Long Run alle Phasen = Easy, max 1 Quality bei comfort, Pflicht-Selbst-Check
- Modell-Wechsel auf `claude-opus-4-7` (bessere Constraint-Folgsamkeit)
- Score-Sprung von 4/10 auf 9/10 verifiziert

### 7 · Plan-Versionierung & Improvement-Workflow
- Coach-Verbesserungen direkt überschreiben (1 Backup für Rollback)
- Coach-Verbesserungen als **neue Version (v2)** als Kopie — Original bleibt
- Versionsnummer automatisch (v2, v3, …)
- `showPlanComparisonAfterImprovement` mit Score-Tafel
- `activateNewPlanKeepProgress` — Done-Status, Feedback, Pace-Faktor, Wochen-Position übertragen
- `activateNewPlanFresh` — neu bei Woche 1
- `basedOnPlanId` als Verknüpfung zum Original

### 8 · Adaptiver Loop (KI passt an Feedback an)
- `adaptPlanFromFeedback(plan)` — analysiert ALLE Feedbacks, optimiert nur die noch nicht abgeschlossenen Wochen
- Coach-Banner-Vorschlag „Plan an dein Feedback anpassen" ab 4 Bewertungen (höchste Priorität)
- Sheet-Button für manuelle Auslösung ab 3 Bewertungen
- Erledigte Wochen bleiben unverändert in der neuen Version

### 9 · Form-Erweiterung
- **Lauferfahrung** (Anfänger / 1–3 J / 3+ J / Wettkampf)
- **5 km Bestzeit** (Min:Sek)
- **Längster Lauf bisher** (km)
- **Zielpace pro km** (optional)
- **Wochentage frei wählbar** (Multi-Select Mo–So)
- **Wochenanzahl frei** (4–16 statt Dropdown)
- **Wettkampftermin** (Plan rückwärts geplant)
- **Trainingsumgebung** (Indoor/Outdoor/Mix)
- **Verletzungen / Beschwerden** Freitext
- Form-Hilfetexte einheitlich (`.pe-help`-Klasse, Daniels-Definition für Easy-Pace)
- Defaults: Erfahrung „3+", längster Lauf 10 km, Easy 8,5, Wochen 6, Laufband, Ziel „festigen", WU/CD 400/400

### 10 · Laufband-Tabelle (statt Pace-Chips)
- Spalten **Distanz · km/h · ↗ · Zeit** (User-Anforderung: gleiche Reihenfolge wie am Laufband)
- `parsePaceLine` parst alle KI-Notations-Varianten (km, m, Min, s, mit/ohne Wiederholung)
- Distanz wird IMMER berechnet — auch bei zeitbasierten Sessions („8 Min @ 9,9" → „1,3 km")
- Long Run mit identischen Phasen → eine Zeile (`X km gleichmäßig`) statt 3
- Strides bekommen automatische Trabpause-Zeile mit korrekter Easy-basierter Pace
- Σ-Workout-Zeile am Ende
- Pause-Erkennung nur bei „Pause:" am String-Anfang (nicht mittendrin)

### 11 · API-Robustheit
- `callAnthropic` Helper mit 3-fach Retry + exponentiellem Backoff (1s/2s/4s)
- 1500 ms Pause zwischen Plan-Generierung und Coach-Review (Race-Schutz)
- `silent`-Mode für Reviews bei Copy/Adapt-Workflows (kein Sheet-Flackern)
- Auto-Coach-Review nach Plan-Erstellung (silent + renderTracker bei Erfolg)
- API-Key Auto-Save bei jedem Tastendruck (`oninput`)
- API-Key anzeigen + in Zwischenablage kopieren (für AirDrop aufs iPhone)
- Coach-Review-Fehler nicht mehr Show-Stopper — Plan bleibt erhalten

### 12 · Plan-Persistenz & State
- `load()` neu: kein Auto-Reseed wenn alle Pläne bewusst gelöscht
- `state.lastScreen` persistiert — Reload landet auf zuletzt offenem Tab
- `state.donePace[k]` einfriert Pace-Faktor zum Abhakzeitpunkt (erledigte Tage unverändert bei Slider-Änderungen)
- `state.feedback[k]` für easy/ok/hard-Bewertungen
- `state.coachDismiss[k]` für ignorierte Vorschläge
- `plan.distance`-Migration aus letztem lang-Lauf abgeleitet
- Plan löschen räumt alle Sub-States des Plans auf

### 13 · Mobile/iPhone-Setup
- Versions-Badge oben links (orange, fett, sichtbar) — bei jedem Code-Push manuell hochgezählt
- `sw.js` v3→v4 — HTML network-first (Updates kommen sofort durch)
- `Server starten.command` mit no-cache HTTP-Headers (Python-Inline-Script)
- Hilfe-Sheet mit Setup-Anleitung für iPhone-Updates
- Klare Trennung: localStorage gerätelokal, Pläne nicht zwischen Mac/iPhone synchronisiert

### 14 · Bug-Fixes
- Floating-Point-Display `7,500000000001 km` → `7,5 km`
- Theme-Button-Überlagerung der Score-Anzeige (Padding rechts)
- Komma als Dezimaltrennzeichen (`8,5` und `8.5` beide akzeptiert)
- `type="number"` → `type="text" inputmode="decimal"` (mobile-friendly Tastatur, kein Spinner)
- Default-Plan-Reseed-Bug (kam nach Löschen wieder zurück)
- „Ziel am Ende"-Anzeige zeigt Zieldistanz statt Pre-Taper-Peak
- „Coach-Review starten" startet nicht automatisch (Auto-Trigger fehlte → silent + renderTracker)
- Strides fälschlich als Pause markiert (Regex: nur „Pause:" am Anfang)
- Synthetische Trabpause hardcoded auf 6,5 km/h (jetzt dynamisch aus `plan.basePace - 1.5`)
- Plan-Erstellen ohne Feldwerte (Defaults wurden nicht gesetzt) → fix in `readCreateForm`
- Plans-Liste zeigt Score-Badge zusätzlich (klickbar, öffnet Sheet auch für inaktive Pläne)

---

## Was als Nächstes ansteht

### Hauptauftrag (offen)
- **Realer Trainingseinsatz** — User läuft heute Mo (4 km locker), trackt mit Feedback (easy/passt/hart). Nach 4 Bewertungen meldet sich der Coach-Banner für adaptive Anpassung
- **Verifizierung Coach-Score** auf iPhone bei frisch erstelltem Plan (sollte 8-9/10 sein, war auf Mac 9/10)

### Konkrete Cherry-Picks (offen, für spätere Sessions)
- **Plan-Sync Mac↔iPhone** via OneDrive-JSON-Export/Import — User nutzt aktuell beide Geräte parallel, Pläne sind aber gerätelokal
- **Zieldistanz im Edit-Modal editierbar** — aktuell nur initial setzbar, falls Migration falsch schätzt kann User nicht korrigieren
- **PNG-Versionen vom neuen Logo** generieren (icon-180.png, icon-192.png, icon-512.png) — aktuell nur SVG aktualisiert
- **Wochentage und Wochenanzahl im Edit-Modal** (aktuell read-only, weil strukturell)
- **Zielpace-Override für Long Runs explizit** falls User „Race"-Goal hat aber Long Runs in spezifischer Race-Pace will

### Nicht angefasst (parkiert)
- Hosting-Wechsel auf Netlify (User bleibt bei lokalem Mac-Server)
- Plan-Verlauf / mehrere Coach-Reviews im Zeitverlauf speichern (aktuell nur 1 aktueller Review pro Plan)
- Pro-Session-Steigung über Hill-Training-Notation hinaus (z.B. Anstiegs-Profil je Phase)
- Push-Notifications für nächstes Training

---

## Code-Einstiegspunkte (aktueller Stand)

| Bereich | Funktion / Stelle | Inhalt |
|---|---|---|
| Coach-Methodik (zentral) | `COACH_PERSONA_INTRO`, `COACH_HARD_RULES` | Single-Source für Daniels/Seiler/Lydiard-Regeln, beide Prompts nutzen sie |
| Plan-Generator | `buildPlanPrompt(o)` | Plan-Prompt mit Coach-Persona + harten Constraints + JSON-Beispiel |
| Plan-Erstellung API | `generatePlan()` | Form lesen, KI-Call, Plan speichern, Auto-Coach-Review starten |
| Coach-Review | `reviewPlanWithCoach(plan, btnEl, opts)` | mit `silent`-Mode für Hintergrund-Calls |
| Coach-Review-Anzeige | `showCoachReview(plan)` | Sheet mit Score-Tafel + Stärken/Schwächen/Verbesserungen |
| Plan-Verbesserungen direkt | `applyCoachImprovements(plan, btnEl)` | Plan überschreiben, 1 Backup für Rollback |
| Plan-Verbesserungen als Kopie | `createImprovedPlanCopy(plan, btnEl)` | v2 als neuer Plan, Score-Vergleich |
| Plan-Vergleichs-Sheet | `showPlanComparisonAfterImprovement(originalId, newId)` | Score-Tafel + Aktivierungs-Optionen |
| Plan aktivieren mit Fortschritt | `activateNewPlanKeepProgress(newId, originalId)` | Done/donePace/feedback-Transfer |
| Plan aktivieren neu | `activateNewPlanFresh(newId, originalId)` | Frischstart bei Woche 1 |
| Adaptive Anpassung | `adaptPlanFromFeedback(plan, btnEl)` | KI optimiert nur nicht-abgeschlossene Wochen basierend auf Feedback |
| KI-Verlängerung | `extendPlanWithAI(plan)` | 3 Aufbauwochen Richtung nächster Distanz |
| Coach-Banner-Vorschläge | `coachSuggest(plan)` | Heuristik: adaptFeedback (4+ Feedback) > extend (80%+) > tempoUp/Down > langLong |
| Vorgängerversion zurück | `rollbackPlanVersion(planId)` | Backup wiederherstellen |
| API-Helper | `callAnthropic(body, opts)` | 3-fach Retry, exponentielles Backoff |
| Pace-Skalierung | `scalePaceStr`, `scaledKmh`, `scaledPace` | Tempo-Slider + Steigung-Notation |
| Pace-Tabelle (Render) | `renderPaceTable(paces, incl, factor, basePace)` | mit Auto-Trabpause für Strides + Σ-Zeile |
| Long-Run-Tabelle | `renderLangTable(lang, incl, factor)` | 1 Zeile bei identischen Phasen, sonst 3 |
| Pace-Parser | `parsePaceLine(str, incl, factor)` | erkennt km, m, Min, s + Wiederholung + Steigungs-Notation |
| Distanz-Format | `formatDist(km)` (in parsePaceLine) | „X,X km" oder „XXX m" je nach Größe |
| Ziel-am-Ende | `targetTime(plan)` | nutzt `plan.distance` + Easy oder Zielpace |
| Bake-In | `bakeInPace(planId)` | rechnet alle Pace-Strings × Faktor, Slider zurück auf 0 |
| Plan-Defaults | `ensurePlanDefaults()` | Migration für startDate/basePace/incline/distance/etc. |
| Plan-Speicherung | `state.plans.push(newPlan)` in 2 Stellen | mit allen Metadaten + Auto-Review |
| Form-Lesung | `readCreateForm()` | inkl. Komma→Punkt, Wochentage-Sortierung, Long-Run-Day-Korrektur |
| Edit-Modal | `openPlanEdit(id)` / `savePlanEdit()` | inkl. Erfahrung, Bestzeit, Längster Lauf, Zielpace, WU/CD |
| Help-Sheet | `openHelpSheet()` | Setup-Anleitung für iPhone-Updates, Mac-Server, Daten-Sync |
| Versions-Badge | `APP_VERSION`-Konstante + Init-Code unten | manuell bei jedem Code-Push hochzählen |
| Komma-Eingabe-Helper | `numFromInput(id)` | parseFloat mit Komma→Punkt-Konversion |
| Icon-System | `ICONS` + `icon(name, size, opts)` | Lucide-style SVG-Inline |
| Service Worker | `sw.js` (CACHE = 'laufplan-v4') | network-first für HTML, cache-first für Assets |
| No-Cache-Server | `Server starten.command` | Python-Inline-Script mit Cache-Control: no-store |
| Logo | `icon.svg` | J-Kurve + Peak + 3 Stride-Markierungen |

---

## Memory-Stand

- **Agent `coach-running`** angelegt unter `~/.claude/agents/coach-running.md` — kann in künftigen Sessions direkt aufgerufen werden für Plan-Reviews, methodisch nach Daniels/Seiler/Lydiard

---

## Start-Prompt für nächste Session

```
Lies Laufplan App/SESSION-HANDOFF-2026-05-04-night.md.

Kurz-Status: Laufplan App komplett überarbeitet. Coach-Loop mit KI funktioniert
(Score 9/10 mit Opus + neuem Generator). Plan-Versionierung mit Fortschritts-
Übernahme drin. Adaptive Anpassung an Feedback-Historie integriert. App läuft
auf Mac und iPhone (lokaler Server mit no-cache Headers, sw.js v4 mit
network-first). Versions-Badge oben links zeigt v 2026-05-04-18:40.

Heute: <hier eintragen — Optionen sind: Plan-Sync Mac↔iPhone via OneDrive-JSON,
Zieldistanz im Edit-Modal editierbar, PNG-Logos generieren, oder ganz anderes
Thema>
```

---

**Pfad des Handoffs:** [Laufplan App/SESSION-HANDOFF-2026-05-04-night.md](Laufplan App/SESSION-HANDOFF-2026-05-04-night.md)
