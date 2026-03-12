#import "@preview/fancy-units:0.1.1": num, qty, unit
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8"

#let fonts-state = state("fonts", (
    non-cjk: regex("[\u0000-\u2023]"),
    serif: "New Computer Modern", // or "Libertinus Serif" or "Source Serif Pro"
    serif-cjk: "Harano Aji Mincho", // or "Yu Mincho" or "Hiragino Mincho ProN"
    sans: "Source Sans Pro", // or "Arial" or "New Computer Modern Sans" or "Libertinus Sans"
    sans-cjk: "Harano Aji Gothic",
))
#let mytext(body) = context {
    let (non-cjk, serif, serif-cjk) = fonts-state.get()
    set text(lang: "jp", font: ((name: serif, covers: non-cjk), serif-cjk))

    body
}

#let t-rm(t) = context {
    let (non-cjk, serif, serif-cjk) = fonts-state.get()
    text(font: ((name: serif, covers: non-cjk), serif-cjk), t)
}
#let t-gt(t) = context {
    let (non-cjk, sans, sans-cjk) = fonts-state.get()
    text(font: ((name: sans, covers: non-cjk), sans-cjk), t)
}
#let t-bf(t) = { text(weight: "bold", t) }
#let t-ita(t) = { text(style: "italic", t) }

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

// #show: mytext
