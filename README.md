# Visual Zone — Road to Vostok

A color grading mod for **Road to Vostok** that brings the visual atmosphere of STALKER and Escape from Tarkov to the game. Select from handcrafted LUT presets or fine-tune the image with exposure, contrast and saturation sliders — all through the Mod Configuration Menu, with no keybinds or separate UI.

---

## How it Works

The mod places an invisible quad mesh directly in front of the camera — like a pair of tinted lenses. A custom GLSL shader reads every pixel the game renders, applies the selected LUT and slider adjustments, and writes the result back to the screen in real time. Switching presets or moving a slider takes effect instantly without restarting the game.

When **Default** is selected the mesh is hidden entirely, leaving the image exactly as the game renders it.

---

## Features

- **6 LUT presets** inspired by STALKER and Escape from Tarkov
- **Exposure slider** — overall image brightness
- **Contrast slider** — difference between bright and dark areas
- **Saturation slider** — color intensity
- **LUT Intensity slider** — blend between the original image and the selected LUT
- **Default preset** — disables all mod effects, full vanilla image
- All settings saved automatically and restored on next launch
- Fully compatible with other visual mods

---

## Requirements
- Road to Vostok
- Mod Configuration Menu

---

## Installation
1. Run `build.bat` inside `visual_zone/`
2. Copy `visual_zone.vmz` to your `mods/` folder
   ```
   Road to Vostok/mods/visual_zone.vmz
   ```

---

## LUT Presets
 
| Preset | Inspired by | Feeling |
|---|---|---|
| **Default** | — | Vanilla, no changes |
| **Zone** | STALKER Anomaly / GAMMA | Green-yellow tones, dark and oppressive |
| **Pripyat** | STALKER Clear Sky | Cold, desaturated, grey-blue skies |
| **Anomaly** | STALKER Shadow of Chornobyl | High contrast, deep shadows, crushed blacks |
| **Tarkov** | EFT Factory / Customs | Brown-grey, very desaturated, industrial |
| **Woods** | EFT Woods / Shoreline | Cold green, hostile nature |
| **Reserve** | EFT Reserve / Lighthouse | Near monochrome, military |
 
---

## Sliders
 
All sliders are available in the MCM under **Visual Zone**.
 
| Slider | Range | Default | Description |
|---|---|---|---|
| LUT Preset | — | Default | Selects the color grading preset |
| LUT Intensity | 0.0 – 1.0 | 0.85 | Blends between original and LUT |
| Exposure | 0.0 – 3.0 | 0.8 | Overall brightness |
| Contrast | 0.5 – 2.0 | 1.0 | Bright vs dark difference |
| Saturation | 0.0 – 2.0 | 1.25 | Color intensity |
 
> Note: sliders have no effect when Default is selected. Default hides the shader mesh entirely for a true vanilla image.
 
---

## Planned features
 
- SSAO and SSIL toggles
- Additional LUT presets
- Vignette slider
- Fog density controls
---

## Building
Requires 7-Zip installed at `C:\Program Files\7-Zip\`
Run `build.bat` from inside the `visual_zone/` folder.

---

## License

MIT — free to use, modify and redistribute with attribution.

---

## Credits
 
LUT textures generated procedurally using color science transforms inspired by the visual style of STALKER and Escape from Tarkov.  
Shader architecture based on community research into Godot 4 post-process techniques.  