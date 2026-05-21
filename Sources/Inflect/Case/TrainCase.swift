/// Converts `string` to Train-Case.
///
/// Every word is capitalised and words are joined with `-`.
/// Examples: `"fooBar"` → `"Foo-Bar"`, `"foo_bar"` → `"Foo-Bar"`
func toTrainCase(_ string: String) -> String {
    toCaseCamelLike(string, options: CamelOptions(
        newWord: true,
        lastChar: " ",
        firstWord: true,
        injectableChar: "-",
        hasSeparator: true,
        inverted: false
    ))
}

/// Returns `true` when `string` is already in Train-Case.
func isTrainCase(_ string: String) -> Bool {
    toTrainCase(string) == string
}
