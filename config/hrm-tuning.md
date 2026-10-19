# Home Row Mods — Tuning Guide

Tuning reference for the positional ("timeless") HRM setup in
[`config/includes/behaviours_homerow_mods.dtsi`](includes/behaviours_homerow_mods.dtsi),
based on urob's method: <https://github.com/urob/zmk-config#timeless-homerow-mods>

## How this HRM setup decides

The architecture is **largely self-tuning**, so most timings should *not* change
as typing speed increases:

- `flavor = "balanced"` — the mod fires when the opposite-hand trigger key is
  **released** (not after a timeout).
- `hold-trigger-key-positions` + `hold-trigger-on-release` — same-hand rolls are
  forced to taps; the decision waits for the roll key's release, so decision
  latency automatically shrinks as you type faster.
- `require-prior-idle-ms` — the only knob that meaningfully tracks typing speed.

> **Important:** `flavor` must stay `"balanced"`. With `"tap-preferred"` the
> hold-tap ignores other-key events entirely, so any chord faster than the full
> tapping term (Cmd+A, Shift+letter) resolves as **two letters**. This was the
> original bug in this config — don't reintroduce it while "tuning".

## Where the timings live

Top of `behaviours_homerow_mods.dtsi`:

```c
#define HM_TAPPING_TERM 250       // lone-hold fallback for ctrl/gui/alt
#define HM_TAPPING_TERM_FAST 200  // lone-hold fallback for shift
#define HM_PRIOR_IDLE 100         // require-prior-idle-ms
```

Plus `quick-tap-ms = <175>` (inline, per behavior).

## What each knob does

| Knob | What it actually controls | Speed-sensitive? |
| --- | --- | --- |
| `HM_TAPPING_TERM` / `_FAST` | Only edge cases: lone holds (mod pressed with no other key) and the no-other-key fallback. Chords never wait for it. | No |
| `HM_PRIOR_IDLE` | Forces a tap if the HRM key is pressed within N ms of the last keystroke. The "typing mode vs command mode" separator. | **Yes — the main tuning knob** |
| `quick-tap-ms` | Double letters (`ee`, `oo`) on HRM keys: second press inside the window repeats the tap. It's a max window — faster doubles are *more* likely to fit inside. | No |

## Why `HM_PRIOR_IDLE` tracks typing speed

Higher WPM → shorter inter-key intervals → a fixed window catches a larger
share of key presses:

| Typing speed | Avg. inter-key interval | Effect of a 100 ms window |
| --- | --- | --- |
| 40 WPM | ~300 ms | Almost never triggers — chords always work |
| 60–70 WPM | ~180–200 ms | Rarely triggers |
| 90–100 WPM | ~120–150 ms | Occasionally catches deliberate chords |
| 120+ WPM | ~100 ms | Catches nearly everything — must be tuned |

## Symptom-driven tuning

Retune **one value at a time**, and only when a symptom appears. Flash, type
for a few days, evaluate.

| Symptom | Fix |
| --- | --- |
| Chords (Cmd+A, Shift+letter) fail when issued immediately after typing | Lower `HM_PRIOR_IDLE` → try `75` |
| Accidental mods during fast cross-hand bigrams (e.g. `a`+`k` across halves produces Ctrl+K) | Raise `HM_PRIOR_IDLE` → try `125`–`150` (urob, a very fast typist, uses `150`) |
| Mod-only holds feel laggy (press Cmd, hold, press the letter much later) | Lower `HM_TAPPING_TERM` — that latency is capped by it |
| Second press of a doubled HRM letter (`ee`) activates the mod instead of repeating | Raise `quick-tap-ms` |

## Current status (baseline)

- Typing speed: ~40 WPM (~300 ms inter-key intervals).
- `HM_PRIOR_IDLE 100` is doing almost nothing during normal typing and gives
  clean, reliable chords — **no changes recommended yet**.
- Revisit `HM_PRIOR_IDLE` around 70–90 WPM, guided by the symptom table above.

## Things that are by design (not tuning problems)

- **Same-hand shift+letter** (e.g. F+A, both left) always taps — use the
  opposite-hand shift (J) for left-hand letters. This is inherent to
  positional HRM.
- **Release order matters**: release the letter *before* releasing the mod key.
  Releasing the mod first while still inside the tapping term gives a tap —
  true for every flavor.
- Deliberate chords work at any speed below the tapping term; there is no
  need to hold the mod for 200+ ms.

## Tuning procedure

1. Pick the single symptom from the table above.
2. Change exactly one value in `behaviours_homerow_mods.dtsi`.
3. Rebuild and flash.
4. Type normally for a few days before judging — one bad chord is noise,
   a daily pattern is signal.
5. Keep values that remove the symptom *without* introducing the opposite one.
