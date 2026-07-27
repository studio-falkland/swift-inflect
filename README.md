<p align="center">
<img src="./Documentation/logo.svg" />
</p>

<p></p>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-6.0+-F05138?logo=swift&logoColor=white" alt="Swift 6.0+"></a>
  <a href="https://swift.org/package-manager"><img src="https://img.shields.io/badge/SPM-compatible-4BC51D?logo=swift&logoColor=white" alt="SPM Compatible"></a>
  <a href="https://github.com/studio-falkland/swift-inflect/releases"><img src="https://img.shields.io/github/v/release/studio-falkland/swift-inflect?color=blue" alt="Latest Release"></a>
  <a href="LICENSE.md"><img src="https://img.shields.io/github/license/studio-falkland/swift-inflect" alt="License"></a>
</p>

## Introduction
`swift-inflect` is a pure Swift port of the [Rust Inflector](https://github.com/whatisinternet/Inflector) library by Josh Teeter. It adds English string inflections to `String` and all numeric types with zero external dependencies.

You can use to convert into: 
* camelCase
* PascalCase
* snake_case
* SCREAMING_SNAKE_CASE
* kebab-case
* a URL-safe slug
* and many more...

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/studio-falkland/swift-inflect", from: "1.0.0"),
],
targets: [
    .target(name: "YourTarget", dependencies: [
        .product(name: "Inflect", package: "swift-inflect"),
    ]),
]
```

## API

All methods are available as extensions on `String`. Transformation methods return `String`; boolean checks are computed properties.

### Case conversions

| Method | Example |
|---|---|
| `toCamelCase()` | `"foo_bar"` → `"fooBar"` |
| `toPascalCase()` | `"foo_bar"` → `"FooBar"` |
| `toSnakeCase()` | `"fooBar"` → `"foo_bar"` |
| `toScreamingSnakeCase()` | `"fooBar"` → `"FOO_BAR"` |
| `toKebabCase()` | `"fooBar"` → `"foo-bar"` |
| `toTrainCase()` | `"fooBar"` → `"Foo-Bar"` |
| `toSlug()` | `"Foo, bar!"` → `"foo-bar"` |
| `toSentenceCase()` | `"fooBar"` → `"Foo bar"` |
| `toTitleCase()` | `"fooBar"` → `"Foo Bar"` |
| `toClassCase()` | `"foo_bars"` → `"FooBar"` |
| `toTableCase()` | `"fooBar"` → `"foo_bars"` |

Each case has a matching boolean predicate — a computed property with no parentheses:

```swift
"fooBar".isCamelCase          // true
"foo_bar".isSnakeCase         // true
"FOO_BAR".isScreamingSnakeCase // true
"Foo-Bar".isTrainCase         // true
"hello-world".isSlug          // true
```

### Numbers

```swift
"1".ordinalized()     // "1st"
"2".ordinalized()     // "2nd"
"11".ordinalized()    // "11th"
"0.1".ordinalized()   // "0.1"  (decimals are unchanged)
"1st".deordinalized() // "1"
```

`ordinalized()` is also available directly on all numeric types (`Int`, `Int8` … `UInt64`, `Float`, `Double`):

```swift
1.ordinalized()       // "1st"
(1 as Int8).ordinalized()   // "1st"
(1.0 as Double).ordinalized() // "1st"
```

### Foreign key

```swift
"Foo::Bar".toForeignKey()  // "bar_id"
"FooBar".toForeignKey()    // "foo_bar_id"
"bar_id".isForeignKey      // true
```

### Pluralize / Singularize

```swift
"crate".pluralized()    // "crates"
"crates".singularized() // "crate"
"ox".pluralized()       // "oxen"
"geometry".pluralized() // "geometries"
```

202 uncountable mass nouns (e.g. `"furniture"`, `"rice"`, `"yoga"`) are returned unchanged.

### Module paths

```swift
"Foo::Bar".demodulized()    // "Bar"   (last component)
"Foo::Bar".deconstantized() // "Foo"   (second-to-last component)
"Test::Foo::Bar".demodulized()    // "Bar"
"Test::Foo::Bar".deconstantized() // "Foo"
```

### Slug

`toSlug()` is meant for generating URL slugs. Non-alphanumeric characters are dropped, 
Latin diacritics are folded to ASCII (`é` → `e`), and words are joined with `-`.

```swift
"Hello, World!".toSlug() // "hello-world"
"Café Olé".toSlug()      // "cafe-ole"
"foo bar".toSlug()       // "foo-bar"
```

## Usage example

```swift
import Inflect

let s = "foo_bar_baz"
print(s.toCamelCase())         // fooBarBaz
print(s.toPascalCase())        // FooBarBaz
print(s.toScreamingSnakeCase()) // FOO_BAR_BAZ
print(s.toKebabCase())         // foo-bar-baz
print(s.toTitleCase())         // Foo Bar Baz
print(s.toTableCase())         // foo_bar_bazs  (snake + pluralise last word)

print("replies".singularized()) // reply
print("knife".pluralized())     // knives

print("Hello, World!".toSlug()) // hello-world
print("Café Olé".toSlug())      // cafe-ole

print(42.ordinalized())  // 42nd
print(11.ordinalized())  // 11th
```

## Running tests

```bash
swift test
```

## Authors

![Studio Falkland](./Documentation/falkland-logo-long-orange.svg)

This library is brought to you by Studio Falkland and was developed by Lei Nelissen.

### Original Rust library

This library is a Swift port of **Inflector** by Josh Teeter.

- Repository: <https://github.com/whatisinternet/Inflector>
- Documentation: <https://docs.rs/Inflector>
- Crates.io: <https://crates.io/crates/Inflector>

## License
This package is open-source software licensed under BSD 2-Clause. See [LICENSE.md](LICENSE.md).

Original Rust library copyright © 2017 Josh Teeter.
Swift port additions follow the same licence.
