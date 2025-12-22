#import "@preview/unify:0.7.1": *

#let _font-serif = ("Harano Aji Mincho", "Noto Serif JP")
#let _font-sanserif = ("Harano Aji Gothic", "Noto Sans JP")
#let rm(t) = { text(font: _font-serif, t) }
#let gt(t) = { text(font: _font-sanserif, t) }
#let bf(t) = { text(weight: "bold", t) }
#let ita(t) = { text(style: "italic", t) }

#let cudw = rgb("#FFFFFF")
#let cudlgra = rgb("#C8C8CB")
#let cudgra = rgb("#84919E")
#let cudbla = rgb("#000000")
#let cudr = rgb("#FF4B00")
#let cudgre = rgb("#03AF7A")
#let cudblu = rgb("#005AFF")
#let cudsky = rgb("#4DC4FF")
#let cudo = rgb("#F6AA00")
#let cudpu = rgb("#990099")
#let cudpi = rgb("#FF8082")
#let cudbr = rgb("#804000")
#let cudy = rgb("#FFF100")
#let cudlpi = rgb("#FFCABF")
#let cudly = rgb("#FFFF80")
#let cudlyg = rgb("#D8F255")
#let cudlsky = rgb("#BFE4FF")
#let cudlbe = rgb("#FFCA80")
#let cudlgre = rgb("#77D9A8")
#let cudlpu = rgb("#C9ACE6")

#set text(lang: "ja", font: _font-serif)
