/// Converts `string` to Title Case.
///
/// Every word is capitalised and words are separated by a space.
/// Examples: `"fooBar"` → `"Foo Bar"`, `"foo_bar"` → `"Foo Bar"`
func toTitleCase(_ string: borrowing String) -> String {
    toCaseCamelLike(string, options: CamelOptions(
        newWord: true,
        lastChar: " ",
        firstWord: true,
        injectableChar: " ",
        hasSeparator: true,
        inverted: false
    ))
}

/// Returns `true` when `string` is already in Title Case.
func isTitleCase(_ string: borrowing String) -> Bool {
    toTitleCase(string) == string
}
