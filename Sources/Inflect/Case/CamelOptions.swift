/// Configuration passed to `toCaseCamelLike(_:options:)` to control
/// which camel-style case variant is produced.
struct CamelOptions {

    /// Whether the very next character should be treated as the start of a new word.
    var newWord: Bool

    /// The last character that was appended to the result.
    /// Initialised to `" "` so the first real character never triggers a camelCase
    /// boundary detection (space is not lowercase).
    var lastChar: Character

    /// Whether we are still in the first word of the output.
    var firstWord: Bool

    /// The character injected between words when `hasSeparator` is `true`
    /// (e.g. `"-"` for Train-Case, `" "` for Title Case).
    var injectableChar: Character

    /// When `true`, `injectableChar` is inserted between words.
    var hasSeparator: Bool

    /// When `true`, words after the first are lowercased instead of uppercased.
    /// Used for Sentence case where only the first word is capitalised.
    var inverted: Bool
}
