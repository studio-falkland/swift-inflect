/// Converts `string` to snake_case.
///
/// Words are joined with `_` and all characters are lowercased.
/// Examples: `"fooBar"` → `"foo_bar"`, `"FOO_BAR"` → `"foo_bar"`
func toSnakeCase(_ string: String) -> String {
    toCaseSnakeLike(string, replaceWith: "_", upper: false)
}

/// Returns `true` when `string` is already in snake_case.
func isSnakeCase(_ string: String) -> Bool {
    toSnakeCase(string) == string
}
