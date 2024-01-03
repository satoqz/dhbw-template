#let template(
  /// the title of your thesis
  /// type: str
  title: "Thesis Title",
  /// the subtitle, such as "Bachelor's Thesis", "T1000", "T2000" etc.
  /// type: str
  subtitle: "Bachelor's Thesis",
  /// single author name or list of author names
  /// type: str | array<str>
  author: "Author Name",
  /// date of submission
  /// type: datetime
  date: datetime(year: 1970, month: 1, day: 1),
  /// formatting template for the date
  /// type: str
  date-format: "[day].[month].[year]",
  /// List of logos to show at the top of the titlepage
  /// type: array<image>
  logos: (),
  /// Additional details to show at the bottom of the titlepage
  /// type: dictionary<str, str>
  details: (:),
  /// Your abstract
  /// type: content
  abstract: lorem(100),
  /// Dictionary of acronyms
  /// type: dictionary<str, str>
  acronyms: (:),
  /// Rest of the document
  /// type: content
  body,
) = {
  let author = if type(author) != array { (author,) } else { author }
  set document(title: title, author: author, date: date)

  set page(paper: "a4", margin: 2.5cm)
  set pagebreak(weak: true)

  set text(
    size: 12pt,
    font: ("New Computer Modern Sans", "CMU Sans Serif"),
  )

  set par(leading: 1em, justify: true)
  show par: set block(spacing: 1.5em)

  set list(indent: 0.75em)
  set enum(indent: 0.75em)

  set math.equation(numbering: "1")

  set bibliography(title: "References")

  set outline(indent: auto, depth: 3, fill: repeat(" . "))
  show outline: set heading(outlined: true)

  show heading.where(level: 1): set block(above: 2em, below: 2em)
  show heading.where(level: 2): set block(above: 2em, below: 1.5em)
  show heading.where(level: 3): set block(above: 1.5em, below: 1em)

  show heading.where(level: 1): set text(size: 24pt)
  show heading.where(level: 2): set text(size: 20pt)
  show heading.where(level: 3): set text(size: 16pt)

  show heading: it => {
    set par(justify: false)
    if it.level == 1 { pagebreak() }
    if it.numbering == none { it } else {
      grid(
        columns: (auto, auto),
        box(width: 48pt, counter(heading).display()),
        it.body,
      )
    }
  }

  show outline.entry.where(level: 1): it => [
    #if it.element.func() != heading { return it }
    #show ".": ""
    #v(4pt) #strong(it)
  ]

  show raw.where(block: true): set align(left)
  show raw.where(block: true): set par(justify: false)
  show raw.where(block: true): set text(size: 8pt)

  show raw.where(block: true): set block(
    radius: 2pt, inset: 8pt, width: 100%,
    stroke: luma(128), fill: luma(240),
  )

  show raw.where(block: false): box.with(
    radius: 2pt, inset: (x: 3pt), outset: (y: 3pt),
    stroke: luma(128), fill: luma(240),
  )

  {
    set align(center)
    set par(justify: false)

    let author = author.join(" & ")
    let date = date.display(date-format)

    stack(
      spacing: 1fr,
      stack(dir: ltr, spacing: 1fr, ..logos),
      2fr,
      text(size: 20pt, strong(title)),
      text(size: 14pt, strong(subtitle)),
      [presented to the \ *Department of Computer Science*],
      [for the \ *Bachelor of Science*],
      [at the \ *DHBW Stuttgart*],
      [by \ #text(size: 16pt, strong(author))],
      [submitted on \ #strong(date)],
      2fr,
      table(
        columns: (auto, 1fr, auto), align: left, stroke: none,
        ..details.keys().map(it => (strong(it), none)).zip(details.values()).flatten(),
      ),
    )
  }

  align(horizon, [
    #set text(lang: "de")
    #heading(outlined: false, level: 2, [Selbstständigkeitserklärung])

    Ich versichere hiermit, dass ich meine Bachelorarbeit mit dem Thema: #emph(title) selbstständig verfasst und keine anderen als die angegebenen Quellen und Hilfsmittel benutzt habe. Ich versichere zudem, dass die eingereichte elektronische Fassung mit der gedruckten Fassung, falls vorhanden, übereinstimmt.

    #v(16pt)

    Stuttgart, #date.display(date-format)
    #v(32pt)

    #line(length: 256pt)
    #author.join(", ")
    #pagebreak()
  ])

  align(horizon + center, {
    heading(outlined: false, level: 2, [Abstract])
    abstract
    pagebreak()
  })

  set page(numbering: "I")
  counter(page).update(1)

  outline(target: heading, title: "Table of Contents")
  // outline(target: figure.where(kind: image), title: "List of Figures")
  // outline(target: figure.where(kind: raw), title: "List of Listings")

  heading(level: 1, [Acronyms])
  table(
    columns: (auto, auto), inset: (left: 0em, right: 2em), stroke: none,
    ..acronyms.keys().map(strong).zip(acronyms.values()).flatten(),
  )

  set heading(numbering: "1.1")

  [#box() <end-frontmatter>]

  set page(numbering: "1")
  counter(page).update(1)

  body

  set page(numbering: "I")
  context counter(page).update(counter(page).at(<end-frontmatter>).first() + 1)

  bibliography("references.yml")
}
