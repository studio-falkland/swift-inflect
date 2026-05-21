/// Converts `string` to table_case: snake_case with the last word pluralised.
///
/// The algorithm first snake_cases the input, then splits at the last `_` and
/// pluralises the trailing portion.
/// Examples: `"fooBar"` → `"foo_bars"`, `"foo"` → `"foos"`
func toTableCase(_ string: String) -> String {
    let snaked = toSnakeCase(string)

    // Find the last underscore — that is where the final word starts.
    guard let lastUnderscoreIdx = snaked.lastIndex(of: "_") else {
        // No underscore: pluralise the whole snake-cased string.
        return toPlural(snaked)
    }

    let prefix = String(snaked[snaked.startIndex..<lastUnderscoreIdx])
    let suffix = String(snaked[lastUnderscoreIdx...])

    // Keep the prefix unchanged; pluralise only the last word (which includes the leading `_`).
    return prefix + toPlural(suffix)
}

/// Returns `true` when `string` is already in table_case.
func isTableCase(_ string: String) -> Bool {
    toTableCase(string) == string
}
