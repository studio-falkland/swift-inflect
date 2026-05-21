// MARK: - String helpers

/// Removes trailing non-alphanumeric characters from `s`.
/// Mirrors Rust's `trim_right` / `trim_end_matches(is_not_alphanumeric)`.
func trimTrailingNonAlphanumeric(_ s: String) -> String {
    String(s.reversed().drop(while: { !$0.isLetter && !$0.isNumber }).reversed())
}

/// Returns `true` when `c` is not a lowercase letter.
///
/// In the Rust source `char_is_uppercase` is defined as
/// `test_char == test_char.to_ascii_uppercase()`, which means digits and
/// punctuation also satisfy the condition.  The Swift equivalent is simply
/// "not a lowercase letter".
private func isUppercaseRust(_ c: Character) -> Bool {
    !c.isLowercase
}

/// Returns `true` when a word-separator should be inserted *before* `chars[index]`.
///
/// Mirrors Rust's `requires_seperator`: fires when the current character is
/// uppercase (in the Rust sense) and either the next or previous character is
/// lowercase, signalling a camelCase boundary such as the `B` in `"fooBar"`.
private func requiresSeparator(at index: Int, isFirst: Bool, in chars: [Character]) -> Bool {
    guard !isFirst else { return false }
    guard isUppercaseRust(chars[index]) else { return false }

    let nextIsLower = (index + 1 < chars.count) && chars[index + 1].isLowercase
    let prevIsLower = (index > 0) && chars[index - 1].isLowercase

    return nextIsLower || prevIsLower
}

// MARK: - Core conversion functions

/// Converts `string` to a snake-like case: snake_case, SCREAMING_SNAKE_CASE, or kebab-case.
///
/// - Parameters:
///   - string: The source string.
///   - replaceWith: The separator character (`_` or `-`).
///   - upper: Pass `true` to uppercase every output character (SCREAMING_SNAKE).
func toCaseSnakeLike(_ string: String, replaceWith: Character, upper: Bool) -> String {
    var firstCharacter = true
    var result = ""
    let chars = Array(trimTrailingNonAlphanumeric(string))

    for (index, char) in chars.enumerated() {
        if !char.isLetter && !char.isNumber {
            // Non-alphanumeric → treat as separator.
            // Collapse consecutive separators into one.
            if !firstCharacter {
                firstCharacter = true
                result.append(replaceWith)
            }
        } else if requiresSeparator(at: index, isFirst: firstCharacter, in: chars) {
            // camelCase boundary detected: insert separator then the character.
            firstCharacter = false
            result.append(replaceWith)
            result += upper ? char.uppercased() : char.lowercased()
        } else {
            // Ordinary character — just case it.
            firstCharacter = false
            result += upper ? char.uppercased() : char.lowercased()
        }
    }

    return result
}

/// Converts `string` to a camel-like case: camelCase, PascalCase, Train-Case,
/// Sentence case, or Title Case, depending on `options`.
///
/// The algorithm is a direct port of Rust's `to_case_camel_like`.  The key
/// subtlety is that `lastChar` is only updated in the plain-letter branch —
/// it is *not* updated when a word-start character is emitted — which is
/// intentional and matches the Rust behaviour.
func toCaseCamelLike(_ string: String, options: CamelOptions) -> String {
    var newWord = options.newWord
    var firstWord = options.firstWord
    var lastChar = options.lastChar
    var foundRealChar = false
    var result = ""

    for char in trimTrailingNonAlphanumeric(string) {
        let isSep = !char.isLetter && !char.isNumber

        if isSep && foundRealChar {
            // Separator after real content: flag that the next letter starts a new word.
            newWord = true

        } else if !foundRealChar && isSep {
            // Leading separators are ignored entirely.
            continue

        } else if char.isNumber {
            // Digits are passed through verbatim; the next letter starts a new word.
            foundRealChar = true
            newWord = true
            result.append(char)

        } else if newWord || (lastChar.isLowercase && char.isUppercase && lastChar != " ") {
            // Start of a new word — either explicitly flagged or camelCase boundary.
            foundRealChar = true
            newWord = false

            // Inject separator between words when required (Train-Case, Title Case, …).
            if options.hasSeparator && !firstWord {
                result.append(options.injectableChar)
            }

            // First word is always uppercased; subsequent words depend on `inverted`.
            result += (!options.inverted || firstWord) ? char.uppercased() : char.lowercased()
            firstWord = false

        } else {
            // Plain letter in the middle of a word — lowercase it and track it.
            foundRealChar = true
            lastChar = char
            result += char.lowercased()
        }
    }

    return result
}
