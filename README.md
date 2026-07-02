**TL;DR:** Drop one `.lua` file into `external/mods/` and character select
gets paging, live search (by name/author/tag), and on-the-fly tile
resizing. No engine edits, no bundled assets, no screenpack rebuild.
IKEMEN GO nightly only - confirmed broken on stable v0.99.0.

---

## What it does

Character select in IKEMEN GO/MUGEN is usually a static grid: what you see
is what you get, and once a roster gets big, scrolling a giant page of
tiny portraits looking for one character gets old fast. selectplus adds
the things a large or actively-updated roster actually needs - paging,
search, and resizing - without the roster/screenpack maker having to
touch any code or rebuild anything. It reads the screenpack's own grid
layout automatically, so it works with whatever screenpack you're
already playing.

Every feature below can be turned off individually, so if a roster maker
only wants search and not paging, that's one line to change.

## Features

**Pages** - Adds next/prev page browsing when a roster has more
characters than fit on one screen.

**Edge Paging** - Push Right off the last character on the screen to
advance a page. Push Left off the first one to go back a page.

**Tile Scaling** - Resize the character grid on the fly. Portraits, cell
boxes, and the cursor all resize together, so nothing gets misaligned.
Fine control via keyboard (F5/F6), or cycle through preset sizes with a
controller shoulder-button combo.

**Search** - Type a character's name to filter the roster live. The
closest match is prioritized, so typing "ken" finds Ken before it finds
"Broken Warrior."

**Author Search** - Prefix your query with `@` to search by character
author instead of name, e.g. `@pots` finds every character credited to
P.O.T.S.

**Tag/Category Search** - Prefix your query with `#` to filter by
franchise or category, e.g. `#sf` shows every Street Fighter character,
`#kof` shows King of Fighters. This only works if the roster/pack you're
playing has tags set up for it - see the creator section below for how
that's done.

**On-Screen Keyboard** - A controller-navigable key grid so search works
without a hardware keyboard.

**Styling** - The screenpack/roster maker can control how all of this
looks and where it sits on screen, matching their own theme instead of
whatever selectplus defaults to. By default it just uses the
screenpack's own font, so it looks right without anyone having to touch
anything.

## Install

Copy `selectplus.lua` into your build's `external/mods/` folder and
launch. The console prints `selectplus <version> loaded`. To uninstall,
delete the file. That's the whole install process.

## Controls

**Keyboard:** `PageUp`/`PageDown` = prev/next page, Arrow keys = move
cursor (edge paging can trigger at grid edges), `F3` = open/close search,
`F5`/`F6` = shrink/grow tiles.

**Controller:** tap L1/L2 = prev/next page, Right on the last cell / Left
on the first cell = page forward/back, L1+L2 together = cycle tile size
preset, START = open/close on-screen keyboard search, D-pad+A =
navigate/type, B = backspace.

Default logical tokens: L1 = `d`, L2 = `w`, START = `s`, A = `a`, B = `b`.
These, and everything else, can be remapped by whoever set up the build
you're playing.

## Requirements

**IKEMEN GO nightly only.** Confirmed broken on stable v0.99.0 - the game
crashes on reaching character select regardless of screenpack. If your
build crashes going into character select, it's likely running on a
stable release instead of nightly.

---

## For screenpack and roster creators

Everything below is configuration - none of it is needed for someone who
just wants to play. Full reference for all of this is in the README:
<https://github.com/scristopher/Ikemen-selectplus>

**Every feature has an on/off switch and its own settings**, all in one
config block at the top of the file:

```lua
selectplus.PageScrolling = {
    enabled    = true,
    edgePaging = true,
}

selectplus.Search = {
    enabled = true,
    openKey = 'F3',
}

selectplus.IconResize = {
    enabled  = true,
    scaleMin = 0.5,
    scaleMax = 2.0,
    presets  = {0.7, 1.0, 1.3, 1.6, 2.0},
}
```

**Tags** (for `#category` search) come from either an inline param on a
character's line in `select.def`:

```
Ryu, stages/sf.def, sptag = sf|capcom
```

...or an optional separate file (`selectplus_tags.txt`) next to the
build, which lets you tag a whole roster in bulk without editing
`select.def` at all:

```
[sf]
ryu
ken
akuma

morrigan = ds|capcom
```

Both are optional and can be used together - a character can be tagged
in either place, or both. Multiple tags on one character are separated
with `|`.

**Styling** lets you show/hide, reposition, and re-font any text
selectplus draws (page readout, search prompt, on-screen keyboard),
including individual on-screen-keyboard letters. Everything defaults to
your screenpack's own font, so a fresh install already matches your
theme. When you do want to customize an element, it supports:

- `font` - point at any font file from your screenpack.
- `bank` - palette bank, for bitmap-style fonts.
- `color` - color override, mainly needed for TrueType fonts.
- `align` / `scale` - alignment and text size.

Styling has been tested against several structurally different
screenpacks - a stock IKEMEN GO motif, a wide 3x21-grid pack, and a
bitmap-font motif using palette banks - so it holds up across a range of
layouts and font setups, not just one.

**Common setup issues:**

- A custom font renders invisible - TrueType fonts need an explicit
  `color` set; bitmap-style fonts need the right `bank` instead.
- `@` or `#` shows as a box - the font you picked for that element
  doesn't have those characters. Pick a different font.
- Text lands somewhere odd on screen - adjust that element's position in
  the config.

## License

Free to use as-is in any free build, roster, or collection - no credit
required, redistribute the unmodified file freely. This mod must remain
free: no selling it, no paywalls, no bundling into paid products. If you
modify the file or reuse the code, you must credit the original author
and can't present the work as your own. Full terms are in the file's
header.

## Links

GitHub (source, full config/styling reference):
<https://github.com/scristopher/Ikemen-selectplus>

Bugs and feature requests welcome - drop them here or on GitHub.
