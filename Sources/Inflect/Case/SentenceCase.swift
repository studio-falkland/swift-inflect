/// Converts `string` to Sentence case.
///
/// Only the first word is capitalised; subsequent words are lowercased and
/// separated by a space.  `inverted: true` causes the camel-like algorithm
/// to lowercase word-start characters after the first word.
/// Examples: `"fooBar"` → `"Foo bar"`, `"foo_bar"` → `"Foo bar"`
func toSentenceCase(_ string: String) -> String {
    toCaseCamelLike(string, options: CamelOptions(
        newWord: true,
        lastChar: " ",
        firstWord: true,
        injectableChar: " ",
        hasSeparator: true,
        inverted: true
    ))
}

/// Returns `true` when `string` is already in Sentence case.
func isSentenceCase(_ string: String) -> Bool {
    toSentenceCase(string) == string
}
