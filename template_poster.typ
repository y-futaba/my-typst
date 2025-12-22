#import "template_image.typ"
#import "@preview/peace-of-posters:0.5.6" as pop

#set text(lang: "ja", font: "Harano Aji Gothic", weight: "medium")

#pop.update-theme()

#let my-layout = (
    pop.layout-a1
        + (
            "body-size": 27pt,
            "heading-size": 41pt,
            "title-size": 61pt,
            "subtitle-size": 49pt,
            "authors-size": 41pt,
            "institutes-size": 37pt,
            "keywords-size": 33pt,
        )
)
