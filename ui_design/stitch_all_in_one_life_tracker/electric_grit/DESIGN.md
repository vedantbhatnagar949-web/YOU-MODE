---
name: Electric Grit
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#b9cbbc'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#849587'
  outline-variant: '#3a4a3f'
  surface-tint: '#00e38d'
  primary: '#f4fff4'
  on-primary: '#00391f'
  primary-container: '#00ff9f'
  on-primary-container: '#007144'
  inverse-primary: '#006d41'
  secondary: '#ecb2ff'
  on-secondary: '#520071'
  secondary-container: '#cf5cff'
  on-secondary-container: '#480063'
  tertiary: '#f7fdff'
  on-tertiary: '#00363f'
  tertiary-container: '#99ecff'
  on-tertiary-container: '#006c7c'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#55ffa9'
  primary-fixed-dim: '#00e38d'
  on-primary-fixed: '#002110'
  on-primary-fixed-variant: '#005230'
  secondary-fixed: '#f8d8ff'
  secondary-fixed-dim: '#ecb2ff'
  on-secondary-fixed: '#320047'
  on-secondary-fixed-variant: '#74009f'
  tertiary-fixed: '#a5eeff'
  tertiary-fixed-dim: '#00daf8'
  on-tertiary-fixed: '#001f25'
  on-tertiary-fixed-variant: '#004e5a'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Anybody
    fontSize: 80px
    fontWeight: '900'
    lineHeight: 80px
    letterSpacing: -0.04em
  display-lg-mobile:
    fontFamily: Anybody
    fontSize: 48px
    fontWeight: '900'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Anybody
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Anybody
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 36px
  body-lg:
    fontFamily: Archivo Narrow
    fontSize: 20px
    fontWeight: '500'
    lineHeight: 28px
  body-md:
    fontFamily: Archivo Narrow
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Space Mono
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
  label-sm:
    fontFamily: Space Mono
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
spacing:
  base: 4px
  xs: 8px
  sm: 16px
  md: 24px
  lg: 48px
  xl: 80px
  border-width: 3px
  shadow-offset: 6px
---

## Brand & Style

This design system is built on a foundation of **Neo-Brutalism**, capturing a raw, high-energy aesthetic that prioritizes structural clarity and aggressive visual impact. The personality is unapologetic, technical, and vibrant, designed to stand out in a saturated digital landscape.

The style leverages the "Neon Tokyo" palette to create a high-contrast environment where deep shadows and thick strokes define the architecture. By combining 90s digital nostalgia with modern precision, the UI evokes an emotional response of urgency, confidence, and excitement. Expect heavy geometric shapes, high-contrast intersections, and a rejection of traditional soft gradients or subtle transitions.

## Colors

The palette is rooted in a deep, obsidian neutral to provide a stable base for neon accents. 

- **Primary (#00FF9F):** A high-voltage neon green used for critical actions and success states.
- **Secondary (#BD00FF):** A vibrant electric purple for secondary interactions and branding elements.
- **Tertiary (#00E0FF):** A cyan blue for informative highlights and links.
- **Accent (#FF005C):** A hot magenta for warnings, errors, or high-priority calls to action.
- **Surface & Background:** The background is a solid `#0A0A0A`. All cards and containers use `#141414` or high-saturation fills.

All interactive elements must maintain a high contrast ratio against the background. Borders are strictly `#000000` or the primary accent color to ensure maximum definition.

## Typography

Typography in this design system is structural and loud. We use **Anybody** for headlines to leverage its variable weight and aggressive character. It should be used in heavy weights (800-900) to anchor the page.

**Archivo Narrow** serves as the body face, chosen for its industrial efficiency and high legibility in data-dense environments. For technical metadata, labels, and system status, **Space Mono** provides a futuristic, monospaced contrast that reinforces the Neo-Brutalist "under construction" or "hacker" aesthetic. 

Text should rarely be smaller than 12px. Headlines should utilize tight line-heights to create a "blocked" look.

## Layout & Spacing

This design system uses a **Fixed Grid** philosophy built on a 4px baseline. The layout is unapologetically rigid. 

- **Desktop:** 12-column grid, 1200px max-width, 24px gutters.
- **Tablet:** 8-column grid, 16px gutters.
- **Mobile:** 4-column grid, 16px gutters, 16px side margins.

Margins and paddings follow a doubling scale (8, 16, 24, 48, 80). Elements are often intentionally misaligned or offset using "hard shadows" to break the traditional flow while maintaining a strict underlying geometric order. White space is replaced by "black space" or saturated color blocks.

## Elevation & Depth

Depth is not achieved through light and shadow, but through **hard offsets and thick borders**. 

1.  **Borders:** Every container and interactive element must have a solid, 3px or 4px black border.
2.  **Hard Shadows:** Elevation is communicated via a solid, non-blurred color block (usually Black or a darker shade of the element's fill) offset by 6px to the bottom-right.
3.  **No Blurs:** Gaussian blurs, soft drop shadows, and glassmorphism are strictly prohibited.
4.  **Layering:** Elements at a higher z-index use a larger shadow offset and more vibrant fill colors to appear "closer" to the user.

## Shapes

The shape language is strictly **geometric and sharp**. All corners are set to 0px radius. This reinforces the raw, industrial nature of the design system. 

Rectangles, squares, and hard-edged polygons are the primary containers. Interactive states (like hover) may involve "sliding" the container over its hard shadow or changing the border color to a neon highlight, but the sharp edges remain constant.

## Components

### Buttons
Buttons use a saturated fill (Primary or Secondary) with a 3px black border and a 6px hard black shadow. On hover, the button "presses down"—the shadow disappears, and the button translates 4px down and 4px right. Label font is **Space Mono Bold**.

### Input Fields
Inputs are white or very dark grey backgrounds with a thick black border. They do not have shadows when idle. On focus, they gain a neon border (Primary) and a hard shadow. Placeholder text is in **Space Mono**.

### Cards
Cards are the primary container. They feature a 3px black border and a thick hard shadow. Header sections within cards are separated by a 3px horizontal line.

### Chips & Tags
Small, rectangular blocks with 2px borders. Use **Space Mono** for the text. Use the Tertiary color for informational tags and Accent for status-critical tags.

### Lists
List items are separated by heavy 2px horizontal rules. Interactive list items should change their background color to a neon hue on hover, with no transition timing (instant change).

### Additional Components: "The Glitch Sticker"
A unique component for this system: a high-contrast call-out box with a "clipped corner" effect or a zig-zag border, used for alerts or special announcements, typically using the Accent magenta color.