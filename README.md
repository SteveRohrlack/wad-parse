![](https://img.shields.io/badge/Swift-4.1.2-green.svg)

# wad-parse

This is a Doom "wad" parser. Just for fun and to learn stuff.

If you'd like to find out what this is all about:

* [Wikipedia entry](https://en.wikipedia.org/wiki/Doom_WAD)
* [Doom Wiki](https://doomwiki.org/wiki/WAD)
* [Wikia Doom](http://doom.wikia.com/wiki/WAD#Map_data_lumps)
* [unoffical docs](http://www.gamers.org/dhs/helpdocs/dmsp1666.html)

## Compatibility

The parser has been tested with the Doom 1 wad file and should be compatible to the Doom 2 format as well.

## State

In it's current state, the parser can extract information about the following types of wad-specific data:

* end game text "ENDOOM"
* palettes
* colormaps
* graphics like "M_DOOM" or "STFST11"
* sprites like "BOSSA1"
* sprite groups like "BOSS" (all sprites)
* sprite group subsets for specific rotations like "BOSSA1, BOSSB1, etc."
* flats like "FLOOR0_1"
* PC Speaker sound effects
* stuctured access to levels and the respective lumps (no data yet)

## Usage examples

### parsing a wad

```swift
var wad: Wad

do {
    let parser = try WadParser(filePath: "/path/to/example.wad")
    wad = try parser.parse()
} catch {
	// handle error
}
```

### extracting normal palette

```swift
let palettes = wad.palettes
let normalPalette = palettes?.default
```

### extracting end game text

```swift
let exitTextLump: WadLumpColoredText? = wad.lump(
	named: "ENDOOM", 
	in: .exitText
)
        
let exitText = exitTextLump?.content(
	in: wad.data
) as? WadColoredText
```

### extracting graphics

```swift
// low level access to any kind of graphic
let allGraphics = wad.graphics
let allSprites = wad.sprites

let genericGraphic = wad.graphic(named: "M_DOOM")

let pictureGraphic = wad.graphic(named: "M_DOOM") as? WadGraphicPicture

let flatGraphic = wad.graphic(named: "FLOOR0_1") as? WadGraphicFlat

let spriteGraphic = wad.graphic(named: "BOSSA1") as? WadGraphicSprite

// convencience methods
let sprite = wad.sprite(named: "BOSSA1")

// sprite groups

let group = wad.spriteGroup(named: "BOSS")
```

### working with sprite groups

```swift
// get all sprites starting with the prefix "BOSS"
let group = wad.spriteGroup(named: "BOSS")

// filter group by rotation "1"
let groupRot1 = group?.groupFor(rotation: 1)

// get a CGRect that encloses all frames, origin respects graphic offsets
let enclosingFrame = groupRot1?.enclosingFrame
```