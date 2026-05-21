/// Converts `string` to PascalCase (UpperCamelCase).
///
/// Identical to camelCase except the first word is also capitalised.
/// Examples: `"foo_bar"` → `"FooBar"`, `"fooBar"` → `"FooBar"`
func toPascalCase(_ string: String) -> String {
    toCaseCamelLike(string, options: CamelOptions(
        newWord: true,
        lastChar: " ",
        firstWord: false,
        injectableChar: " ",
        hasSeparator: false,
        inverted: false
    ))
}

/// Returns `true` when `string` is already in PascalCase.
func isPascalCase(_ string: String) -> Bool {
    toPascalCase(string) == string
}
