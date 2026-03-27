#import "template_image.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/cjk-spacer:0.2.0": cjk-spacer
#import "@preview/equate:0.3.2": equate

#let fonts-state = state("fonts", (
    non-cjk: regex("[\u0000-\u2023]"),
    serif: "New Computer Modern", // or "Libertinus Serif" or "Source Serif Pro"
    serif-cjk: "Harano Aji Mincho", // or "Yu Mincho" or "Hiragino Mincho ProN"
    sans: "Source Sans Pro", // or "Arial" or "New Computer Modern Sans" or "Libertinus Sans"
    sans-cjk: "Harano Aji Gothic",
))

#let myreport(
    lang: "ja",
    seriffont: "New Computer Modern", // or "Libertinus Serif" or "Source Serif Pro"
    seriffont-cjk: "Harano Aji Mincho", // or "Yu Mincho" or "Hiragino Mincho ProN"
    sansfont: "Source Sans Pro", // or "Arial" or "New Computer Modern Sans" or "Libertinus Sans"
    sansfont-cjk: "Harano Aji Gothic", // or "Yu Gothic" or "Hiragino Kaku Gothic ProN"
    paper: "a4", // "a*", "b*", or (paperwidth, paperheight) e.g. (210mm, 297mm)
    fontsize: 10pt,
    baselineskip: auto,
    textwidth: auto, // or 40em etc. (include 2em column gutter)
    lines-per-page: auto,
    book: false,
    cols: 1,
    non-cjk: regex("[\u0000-\u2023]"), // or "latin-in-cjk"
    cjkheight: 0.88, // height of CJK in em
    body,
) = {
    // ================================================== fonts state ==================================================
    fonts-state.update(d => {
        d.non-cjk = non-cjk
        d.serif = seriffont
        d.serif-cjk = seriffont-cjk
        d.sans = sansfont
        d.sans-cjk = sansfont-cjk
        d
    })
    // ================================================== パッケージ ==================================================
    show: cjk-spacer
    // show: equate
    show: codly-init
    codly(
        header-transform: it => text(fill: white, cjk-latin-spacing: auto, it),
        zebra-fill: none,
        languages: codly-languages,
    )

    // ================================================== テーマカラー ==================================================
    let get-theme-color() = {
        let theme-colors = (
            orange,
            fuchsia,
            eastern,
            olive,
        )
        let idx = counter(heading).get().at(0) - 1
        let c = theme-colors.at(calc.rem(idx, theme-colors.len()))

        (ll: c.lighten(95%), l: c.lighten(80%), t: c, d: c.darken(40%))
    }

    // ================================================== ページ ==================================================
    if paper == "a3" { paper = (297mm, 420mm) }
    if paper == "a4" { paper = (210mm, 297mm) }
    if paper == "a5" { paper = (148mm, 210mm) }
    if paper == "a6" { paper = (105mm, 148mm) }
    if paper == "b4" { paper = (257mm, 364mm) }
    if paper == "b5" { paper = (182mm, 257mm) }
    if paper == "b6" { paper = (128mm, 182mm) }
    let (paperwidth, paperheight) = paper
    if textwidth == auto {
        textwidth = (int(0.76 * paperwidth / (cols * fontsize)) * cols + 2 * (cols - 1)) * fontsize
    }
    if baselineskip == auto { baselineskip = 1.73 * fontsize }
    let xmargin = (paperwidth - textwidth) / 2
    let ymargin = if lines-per-page == auto {
        (paperheight - (int((0.83 * paperheight - fontsize) / baselineskip) * baselineskip + fontsize)) / 2
    } else {
        (paperheight - (baselineskip * (lines-per-page - 1) + fontsize)) / 2
    }
    set columns(gutter: 2em)
    set page(
        width: paperwidth,
        height: paperheight,
        margin: (
            x: xmargin,
            top: if book { ymargin + 0.5 * baselineskip } else { ymargin },
            bottom: if book { ymargin - 0.5 * baselineskip } else { ymargin },
        ),
        columns: cols,
        numbering: "1",
        footer: if book { none } else { auto },
        header: {
            context counter(footnote).update(0)
            if book {
                context {
                    let n = if page.numbering == none { "" } else {
                        counter(page).display() // logical page number
                    }
                    let p = here().page() // physical page number
                    let h1 = heading.where(level: 1)
                    let h1p = query(h1).map(it => it.location().page())
                    if p > 1 and not p in h1p {
                        if calc.odd(p) {
                            let h2 = heading.where(level: 2)
                            let h2last = query(h2.before(here())).at(-1, default: none)
                            let h2next = query(h2.after(here())).at(0, default: none)
                            if h2next != none and h2next.location().page() == p { h2last = h2next }
                            if h2last != none {
                                let c = counter(heading).at(h2last.location())
                                stack(
                                    spacing: 0.2em,
                                    if h2last.numbering == none {
                                        [ #h2last.body #h(1fr) #n ]
                                    } else {
                                        [ #{ c.at(0) }.#{ c.at(1) }#h(1em)#h2last.body #h(1fr) #n ]
                                    },
                                    line(stroke: 0.4pt, length: 100%),
                                )
                            }
                        } else {
                            let h1last = query(h1.before(here())).at(-1, default: none)
                            let h1next = query(h1.after(here())).at(0, default: none)
                            if h1next != none and h1next.location().page() == p { h1last = h1next }
                            if h1last != none {
                                let c = counter(heading).at(h1last.location())
                                stack(
                                    spacing: 0.2em,
                                    if h1last.numbering == none {
                                        [ #n #h(1fr) #h1last.body ]
                                    } else {
                                        [ #n #h(1fr) 第#{ c.at(0) }章#h(1em)#h1last.body ]
                                    },
                                    line(stroke: 0.4pt, length: 100%),
                                )
                            }
                        }
                    }
                }
            }
        },
    )

    // ================================================== テキスト ==================================================
    set text(
        lang: lang,
        font: ((name: seriffont, covers: non-cjk), seriffont-cjk),
        weight: 450,
        size: fontsize,
        top-edge: cjkheight * fontsize,
        costs: (widow: if cols == 1 { 100% } else { 0% }, orphan: if cols == 1 { 100% } else { 0% }),
    )
    set par(
        first-line-indent: (amount: 1em, all: true),
        justify: true,
        spacing: baselineskip - cjkheight * fontsize, // space between paragraphs
        leading: baselineskip - cjkheight * fontsize, // space between lines
    )

    // ================================================== セクション ==================================================
    set heading(numbering: "1.1")
    show heading: set text(
        font: ((name: sansfont, covers: non-cjk), sansfont-cjk),
        weight: 450,
    )
    show heading: it => block(
        above: (if book { 1.75 } else { 1 }) * baselineskip - cjkheight * fontsize,
        below: (if book { 1.25 } else { 1 }) * baselineskip - cjkheight * fontsize,
        breakable: false,
        sticky: true,
    )[
        #if it.numbering != none {
            counter(heading).display()
            h(1em)
        }
        #it.body
    ]

    // ================================================== h1 ==================================================
    show heading.where(level: 1): it => {
        counter(math.equation).update(0)
        // counter(figure.where(kind: image)).update(0)
        // counter(figure.where(kind: table)).update(0)
        // counter(figure.where(kind: raw)).update(0)
        let tc = get-theme-color()
        if book {
            pagebreak(weak: true, to: "odd")
            block[
                #set par(first-line-indent: 0em, spacing: 3 * fontsize, leading: 3 * fontsize)
                #v(2 * baselineskip)
                #if it.numbering != none {
                    let n = counter(heading).get().at(0)
                    text(2 * fontsize, "第" + str(n) + "章")
                    linebreak()
                }
                #text(size: 2.5 * fontsize, it.body)
                #v(2 * baselineskip)
            ]
        } else {
            if counter(page).get().at(0) != 1 { pagebreak() }
            let top-margin = ymargin // set page() の margin 参照
            place(
                top + left,
                dx: -xmargin / 2,
                dy: -top-margin,
                block(
                    width: paperwidth - xmargin,
                    height: top-margin - 1em,
                    fill: tc.l,
                    inset: (x: xmargin / 2),
                    stroke: (top: none, rest: 3pt + tc.d),
                    radius: (bottom: 20pt),
                    align(horizon)[
                        #set par(first-line-indent: 0em)
                        #set text(
                            size: 2em,
                            weight: "bold",
                            fill: tc.d,
                            top-edge: "ascender",
                            bottom-edge: "descender",
                        )
                        #if it.numbering != none {
                            counter(heading).display()
                            h(1em)
                        }
                        #it.body
                    ],
                ),
            )
        }
        codly(
            fill: tc.ll,
            stroke: 1pt + tc.d,
            header-cell-args: (fill: tc.d),
            number-format: it => text(fill: tc.t)[#it],
        )
    }

    // ================================================== h2 ==================================================
    show heading.where(level: 2): it => {
        block(
            width: 100%,
            above: (if book { 2.75 } else { 1 }) * baselineskip - cjkheight * fontsize,
            below: (if book { 1.25 } else { 1 }) * baselineskip - cjkheight * fontsize,
            breakable: false,
            sticky: true,
        )[
            #set par(first-line-indent: 0em)
            #set text(size: (if book { 1.4 } else { 1.2 }) * fontsize)
            #if not book { v(baselineskip / 2 + 0.1 * fontsize) }
            #stack(
                {
                    h(0.5em)
                    if it.numbering != none {
                        counter(heading).display()
                        h(1em)
                    }
                    it.body
                },
                v(0.6em),
                line(length: 100%, stroke: (thickness: 2pt, paint: get-theme-color().d, cap: "round")),
            )
            #if not book { v(baselineskip / 2 - 0.1 * fontsize) }
        ]
    }

    // ================================================== h3 ==================================================
    show heading.where(level: 3): it => {
        let tc = get-theme-color()
        block(
            spacing: baselineskip - cjkheight * fontsize,
            breakable: false,
            sticky: true,
        )[
            #set par(first-line-indent: 0em)
            #set text(top-edge: "ascender", bottom-edge: "descender")
            #box(
                width: 100%,
                fill: tc.l,
                inset: (x: 0.9em, y: 0.2em),
                stroke: (left: 5pt + tc.d),
                {
                    if it.numbering != none {
                        counter(heading).display()
                        h(1em)
                    }
                    it.body
                },
            )
        ]
    }

    // ================================================== 目次 ==================================================
    show outline: body => {
        show heading.where(level: 1): it => {
            set align(center)
            block(
                above: baselineskip - cjkheight * fontsize,
                below: baselineskip - cjkheight * fontsize,
                breakable: false,
                sticky: true,
            )[
                #set par(first-line-indent: 0em)
                #set text(size: 1.4 * fontsize)
                #v(baselineskip / 2 + 0.2 * fontsize)
                #if it.numbering != none {
                    counter(heading).display()
                    h(1em)
                }
                #it.body
                #v(baselineskip / 2 - 0.2 * fontsize)
            ]
        }
        body
    }

    // ================================================== 装飾 ==================================================
    set underline(offset: 1pt)
    show strong: set text(fill: cudbr, weight: "bold")
    show emph: set text(weight: "bold", style: "normal")
    set list(indent: 0.722em, marker: n => context {
        set text(fill: get-theme-color().d)
        ($bullet$, $triangle.stroked.small.r$, t-bf[--]).at(n)
    })
    show list: set block(spacing: 1.5 * baselineskip - cjkheight * fontsize)
    set enum(indent: 0.722em, numbering: (..nums) => context text(font: sansfont, fill: get-theme-color().d, numbering(
        "1.a.i.",
        ..nums,
    )))
    show enum: set block(spacing: 1.5 * baselineskip - cjkheight * fontsize)
    set terms(indent: 2em, separator: h(1em, weak: true))
    show terms: set block(spacing: 1.5 * baselineskip - cjkheight * fontsize)

    set quote(block: true)
    show quote.where(block: true): set pad(left: 2em, right: 0em)
    show quote.where(block: true): set block(spacing: 1.5 * baselineskip - cjkheight * fontsize)

    set footnote.entry(indent: 1.6em)
    set footnote(numbering: n => {
        set text(font: "New Computer Modern Math", baseline: 0pt, size: 1em)
        sym.dagger
    })

    // show raw.where(block: true): set block(width: 100%, fill: luma(240), inset: 1em)
    show raw.where(block: true): set par(justify: false, leading: 0.8 * baselineskip - cjkheight * fontsize)
    show raw.where(block: true): set text(fill: luma(70), top-edge: "bounds", bottom-edge: "bounds")
    show raw.where(block: false): it => {
        highlight(
            {
                let w = measure([a]).width // [a] の横幅を測定
                hide([a]) // 見えない [a]
                sym.wj // 改行を防ぐ単語結合子
                h(-w, weak: false) // [a] の横幅を打ち消す
                sym.wj // 改行を防ぐ単語結合子
                it // 数式本体
                sym.wj // 改行を防ぐ単語結合子
                h(-w, weak: false) // [a] の横幅を打ち消す
                sym.wj // 改行を防ぐ単語結合子
                hide([a]) // 見えない [a]
            },
            fill: luma(240),
            top-edge: 1.2em,
            bottom-edge: -0.5em,
        )
    }

    set table(stroke: 0.04em)
    show table: set text(top-edge: (2 * cjkheight - 1) * fontsize, bottom-edge: "descender")

    show figure.where(kind: table): set figure.caption(position: top)
    set figure(gap: 1em)
    show figure: it => {
        v(1em, weak: true)
        it
        v(1em)
    }
    set figure.caption(separator: h(1em))

    // ================================================== 数式 ==================================================
    set math.equation(number-align: end + bottom)
    show math.equation.where(block: true): set block(spacing: 1.5 * baselineskip - cjkheight * fontsize)
    show math.equation.where(block: false): set math.lr(size: 1em)
    show math.equation.where(block: false): set math.frac(style: "horizontal")
    set math.vec(delim: "[", gap: 0.5em)
    set math.mat(delim: "[", row-gap: 0.5em, column-gap: 0.8em)
    show sym.emptyset: set text(font: "Libertinus Math")
    // math function の改造
    let custom-math-func(bfr, aft) = {
        if bfr.has("label") and bfr.label == <custom-math-stop-recursion> {
            bfr
        } else {
            [#aft<custom-math-stop-recursion>]
        }
    }
    // frac の線を延長
    let add-space-frac(num, den, style) = {
        let s = h(1em / 6)
        if style == "vertical" {
            num = s + num + s
            den = s + den + s
        }
        math.frac(num, den, style: style)
    }
    show math.frac: it => custom-math-func(it, add-space-frac(it.num, it.denom, it.style))
    // root の線を延長
    let add-space-root(idx, rdc) = {
        math.root(idx, rdc + h(1em / 6))
    }
    show math.root: it => custom-math-func(it, add-space-root(it.index, it.radicand))

    // ================================================== numbering と ref ==================================================
    let eq-numbering = "(1.1)"
    let fg-numbering = "1.1"
    set math.equation(
        numbering: (..num) => numbering(eq-numbering, counter(heading).get().at(0), ..num),
        supplement: [式],
    )
    // set figure(gap: 1em, numbering: num => numbering(fg-numbering, counter(heading).get().at(0), num))
    show ref: it => {
        let el = it.element
        if el == none { return it }
        let loc = el.location()
        let sec-count = counter(heading).at(loc)
        let is-figure = el.func() == figure
        let is-eq = el.func() == math.equation
        let is-equate = is-figure and el.kind == math.equation
        let is-h = el.func() == heading
        let is-image = is-figure and el.kind == image
        let is-table = is-figure and el.kind == table

        if is-eq or is-equate {
            let (count,) = counter(math.equation).at(loc)
            if is-equate {
                count = count - 1 // equate(sub-numbering: false) のとき counter がバグるため
            }
            link(it.target, el.supplement + sym.wj + numbering(eq-numbering, sec-count.at(0), count))
        } else if is-h {
            link(it.target, numbering(el.numbering, ..sec-count) + sym.wj + "節")
            // } else if is-figure {
            //     let count = counter(figure.where(kind: el.kind)).at(loc)
            //     link(it.target, el.supplement + sym.wj + numbering(fg-numbering, sec-count.at(0), ..count))
        } else {
            it
        }
    }

    body
}

#let kintou(width, s) = box(width: width, s.text.clusters().join(h(1fr)))
#let scatter(s) = h(1fr) + s.text.clusters().join(h(2fr)) + h(1fr)
#let ruby(kanji, yomi) = box[
    #context {
        set par(first-line-indent: 0em)
        set text(top-edge: "ascender")
        let w = measure(kanji).width
        let x = measure(yomi).width / 2
        if w < x { w = x }
        box(width: w, h(1fr) + kanji + h(1fr)) // or scatter(kanji)
        place(top + center, dy: -0.5em, box(width: w, text(0.5em, scatter(yomi))))
    }
]

#let noindent(body) = {
    set par(first-line-indent: 0em)
    body
}

#let boxtable(x) = {
    if type(x) == array {
        box(
            baseline: 100% - 1.16em, // 100% - (2 * cjkheight - 1.4) * 1em,
            table(stroke: 0pt, inset: 0.4em, columns: 1, align: center, ..x),
        )
    } else {
        box(x)
    }
}

#let array2text(x) = {
    while type(x) == array { x = x.at(0, default: "") }
    x
}

#let authortext(authors) = {
    if type(authors) == array {
        authors.map(array2text).join(", ")
    } else {
        authors
    }
}

#let maketitle(
    title: "",
    authors: "",
    date: datetime.today().display("[year]年[month repr:numerical padding:none]月[day padding:none]日"),
    abstract: [],
    keywords: (),
) = {
    set document(title: title, author: authortext(authors), keywords: keywords)
    place(top + center, scope: "parent", float: true)[
        #set align(center)
        #v(2em)
        #text(1.7em, title)
        #v(1.5em)
        #pad(
            x: 2em,
            if type(authors) == array {
                authors.map(boxtable).join("      ")
            } else {
                authors
            },
        )
        #v(1em)
        #date
        #v(1.5em)
        #if abstract != [] {
            block(width: 90%)[
                #set text(0.9em)
                #text(font: _font-sanserif, weight: 450, [概要])    // 変更
                #align(left)[#abstract]
            ]
            v(1.5em)
        }
    ]
}

#let url(url, content) = underline(text(fill: cudblu, link(url, content)))

#let zero-numbering = (..nums) => {
    {
        (nums.pos().first() - 1,)
        nums.pos().slice(1)
    }
        .map(str)
        .join(".")
}

#let multi-col(w: (1fr,), ..body) = {
    grid(
        columns: if w == (1fr,) { for x in body.pos() { (1fr,) } } else { w },
        gutter: 0.5em,
        align: left,
        ..body
    )
}

#let nonumeq(body) = {
    set math.equation(numbering: none)
    body
}
