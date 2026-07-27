import Foundation

/// Converts `string` to a URL-safe slug.
///
/// Unlike the other case conversions in this library, slugifying drops every
/// non-alphanumeric character (so punctuation and symbols are removed rather
/// than turned into separators) and folds Latin diacritics to their ASCII
/// equivalents via `String.folding(options: .diacriticInsensitive, ...)`.
///
/// Word boundaries are inserted at:
///   * camelCase transitions (`fooBar` → `foo-bar`)
///   * a non-alphanumeric followed by a letter (`Hello, World!` → `hello-world`)
///   * a digit followed by an uppercase letter (`item42` → `item-42`)
///
/// Examples: `"fooBar"` → `"foo-bar"`, `"foo_bar"` → `"foo-bar"`,
///           `"Hello, World!"` → `"hello-world"`,
///           `"don't stop"` → `"dont-stop"`,
///           `"Café Olé"` → `"cafe-ole"`.
func toSlug(_ string: borrowing String) -> String {
    // Fold diacritics to ASCII (é → e, ü → u, ñ → n, …) before splitting.
    let folded = string.folding(options: .diacriticInsensitive, locale: .current)

    var result = ""
    result.reserveCapacity(folded.count)

    var firstCharacter = true
    var prevChar: Character? = nil
    var pendingBoundary = false

    for char in folded {
        if !char.isLetter && !char.isNumber {
            // Drop the non-alphanumeric but remember that the next letter
            // should start a new word.
            pendingBoundary = true
            continue
        }

        let isUpper = !char.isLowercase
        let prevIsLower = prevChar?.isLowercase ?? false
        let needsBoundary = pendingBoundary || (!firstCharacter && isUpper && prevIsLower)

        if needsBoundary && !firstCharacter {
            result.append("-")
        }
        pendingBoundary = false

        firstCharacter = false
        result.append(char.lowercased())
        prevChar = char
    }

    // Trim leading and trailing `-` so we don't produce "-foo-" from
    // "  foo  " or "foo--".
    while result.first == "-" { result.removeFirst() }
    while result.last == "-"  { result.removeLast() }

    return result
}

/// Returns `true` when `string` is already a valid slug.
func isSlug(_ string: borrowing String) -> Bool {
    toSlug(string) == string
}
