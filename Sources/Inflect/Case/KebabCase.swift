/// Converts `string` to kebab-case.
///
/// Words are joined with `-` and all characters are lowercased.
/// Examples: `"fooBar"` → `"foo-bar"`, `"foo_bar"` → `"foo-bar"`
func toKebabCase(_ string: borrowing String) -> String {
    toCaseSnakeLike(string, replaceWith: "-", upper: false)
}

/// Returns `true` when `string` is already in kebab-case.
func isKebabCase(_ string: borrowing String) -> Bool {
    toKebabCase(string) == string
}
