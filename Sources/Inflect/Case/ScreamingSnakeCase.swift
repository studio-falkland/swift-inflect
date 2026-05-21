/// Converts `string` to SCREAMING_SNAKE_CASE.
///
/// Words are joined with `_` and all characters are uppercased.
/// Examples: `"fooBar"` → `"FOO_BAR"`, `"foo_bar"` → `"FOO_BAR"`
func toScreamingSnakeCase(_ string: String) -> String {
    toCaseSnakeLike(string, replaceWith: "_", upper: true)
}

/// Returns `true` when `string` is already in SCREAMING_SNAKE_CASE.
func isScreamingSnakeCase(_ string: String) -> Bool {
    toScreamingSnakeCase(string) == string
}
