/// Converts `string` to camelCase.
///
/// Word boundaries are detected at separator characters (`_`, `-`, spaces)
/// and at transitions from a lowercase to an uppercase letter.
/// Examples: `"foo_bar"` → `"fooBar"`, `"FooBar"` → `"fooBar"`
func toCamelCase(_ string: String) -> String {
    toCaseCamelLike(string, options: CamelOptions(
        newWord: false,
        lastChar: " ",
        firstWord: false,
        injectableChar: " ",
        hasSeparator: false,
        inverted: false
    ))
}

/// Returns `true` when `string` is already in camelCase.
func isCamelCase(_ string: String) -> Bool {
    toCamelCase(string) == string
}
