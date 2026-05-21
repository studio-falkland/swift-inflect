/// Converts `string` to ClassCase: PascalCase with the last word singularised.
///
/// The algorithm first PascalCases the input, then finds the last uppercase
/// letter, splits there, and singularises the trailing portion.
/// Examples: `"foo"` → `"Foo"`, `"foo_bars"` → `"FooBar"`
func toClassCase(_ string: String) -> String {
    let pascal = toPascalCase(string)

    // Find the last uppercase letter — that is where the final word starts.
    guard let lastUpperIdx = pascal.lastIndex(where: { $0.isUppercase }) else {
        // No uppercase letter found: singularise the whole string.
        return toSingular(pascal)
    }

    let prefix = String(pascal[pascal.startIndex..<lastUpperIdx])
    let suffix = String(pascal[lastUpperIdx...])

    // Keep the prefix unchanged; singularise only the last word.
    return prefix + toSingular(suffix)
}

/// Returns `true` when `string` is already in ClassCase.
func isClassCase(_ string: String) -> Bool {
    toClassCase(string) == string
}
