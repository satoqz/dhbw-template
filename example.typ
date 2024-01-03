#import "template.typ" : template

#show: template.with(
  title: "Thesis Title",
  author: "Author Name",
  date: datetime(year: 1970, month: 1, day: 1),
  logos: (
    image("assets/dhbw.svg", width: 30%),
    image("assets/hpe.svg", width: 30%),
  ),
  details: (
    "Company": "Hewlett Packard Enterprise",
    "Supervisor at Company": "Supervisor Name",
    "Supervisor at University": "Supervisor Name",
    "Time Period": "01.01.1970 - 01.01.2000",
    "Course, Student ID": "TINF01A, 1000000",
  ),
  abstract: [
    #lorem(50)
  ],
  acronyms: (
    API: [Application Programming Interface],
    JSON: [JavaScript Object Notation],
  ),
)

= Introduction
#lorem(50) @lorem-ipsum-generator

== Motivation
#lorem(50)

== Structure of this Work
#lorem(50)

= State of Technology
#lorem(50)

= Summary & Conclusion
#lorem(50)

== Summary
#lorem(50)

== Future Work
#lorem(50)

== Conclusion
#lorem(50)