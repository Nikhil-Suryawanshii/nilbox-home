# Splash 01 — Assets & Animation Plan

**Screen:** 01 Splash  
**Code:** `lib/views/common/splash/layouts/splash_layout.dart`  
**Design hold:** `kHoldOnSplashForDesign = false` (auto-navigate enabled)  
**Redesign doc:** `mdFiles/mobile-ui-redesign/screens/01-splash.md`

Product PNGs live in **this folder** (`assets/splash/`). Each product is a separate file so Flutter can animate them independently.

---

## Image files

| File | Role | Status |
|---|---|---|
| `nilbox_logo.png` | Local fallback logo | Present |
| `shoe.png` | Product — shoe | Present |
| `headphones.png` | Product — headphones | Present |
| `smartwatch.png` | Product — smartwatch | Present |
| `shopping_bag.png` | Product — shopping bag | Present |
| `perfume.png` | Product — perfume | Present |
| `sunglasses.png` | Product — sunglasses | Present |
| `nilbox_box.png` | Product — Nilbox delivery box | Present |

Registered in `pubspec.yaml` as `- assets/splash/`.

---

## Animation timeline (~4.5–5s)

```
0.0–0.5s   Logo fade + scale 0.85 → 1.0
0.5–1.0s   Tagline fade + slide up
1.0–2.5s   Products stagger in (headphones → … → nilbox box)
2.5–4.5s   Loading bar 0→100% + staged messages → All Set!
then        Navigate when animation AND init are both ready
```

## Implementation status
- [x] Phase 0 — Assets
- [x] Phase 1 — UI shell
- [x] Phase 2 — Animation
- [x] Phase 3 — Init gate + navigation + dispose
