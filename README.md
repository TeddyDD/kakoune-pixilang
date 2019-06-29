# Pixilang support for Kakoune

> [Pixilang] is a pixel-oriented programming language for small graphics/sound
applications and experiments. Originally created by Alexander Zolotov
(NightRadio) and Mik Razuvaev (Goglus) for non-programmers, demosceners and
designers. It is cross-platform and open source (MIT License).

This plugin adds syntax highlighting and basic completion to [Kakoune] text
editor.

## Installation

Only last stable version of Kakoune is supported.

### Using [plug.kak]

```
plug "TeddyDD/kakoune-pixilang" %{
	set-option global pixilang_path "/path/to/pixilang"
}
```

### Manual

Source `rc/pixilang.kak` from your `kakrc`

## Changelog

- 0.1 2019-06-29:
    - **Kakoune v2019.01.20**
    - **Pixilang 3.7b**

[Pixilang]: http://www.warmplace.ru/soft/pixilang/
[Kakoune]: https://kakoune.org/
[plug.kak]: https://github.com/andreyorst/plug.kak
