// MARK: - String helpers

/// Removes trailing non-alphanumeric characters from `s`.
/// Mirrors Rust's `trim_right` / `trim_end_matches(is_not_alphanumeric)`.
func trimTrailingNonAlphanumeric(_ s: borrowing String) -> String {
    guard let lastIdx = s.lastIndex(where: { $0.isLetter || $0.isNumber }) else {
        return ""
    }
    return String(s[...lastIdx])
}

// MARK: - Core conversion functions

/// Converts `string` to a snake-like case: snake_case, SCREAMING_SNAKE_CASE, or kebab-case.
///
/// - Parameters:
///   - string: The source string.
///   - replaceWith: The separator character (`_` or `-`).
///   - upper: Pass `true` to uppercase every output character (SCREAMING_SNAKE).
func toCaseSnakeLike(_ string: borrowing String, replaceWith: Character, upper: Bool) -> String {
    let trimmed = trimTrailingNonAlphanumeric(string)
    var result = ""
    result.reserveCapacity(trimmed.count)

    var firstCharacter = true
    var prevChar: Character? = nil

    var idx = trimmed.startIndex
    while idx < trimmed.endIndex {
        let char = trimmed[idx]
        let nextIdx = trimmed.index(after: idx)

        if !char.isLetter && !char.isNumber {
            // Non-alphanumeric → treat as separator.
            // Collapse consecutive separators into one.
            if !firstCharacter {
                firstCharacter = true
                result.append(replaceWith)
            }
        } else {
            // isUppercaseRust: a character is "uppercase" in the Rust sense
            // when it is not a lowercase letter (digits and punctuation qualify).
            let charIsUppercaseRust = !char.isLowercase

            // Requires a separator when:
            //   • we've already emitted at least one character (!firstCharacter)
            //   • the current char is "uppercase" (in the Rust sense)
            //   • the next OR previous input char is lowercase (camelCase boundary)
            let nextIsLower = nextIdx < trimmed.endIndex && trimmed[nextIdx].isLowercase
            let prevIsLower = prevChar?.isLowercase ?? false

            if !firstCharacter && charIsUppercaseRust && (nextIsLower || prevIsLower) {
                result.append(replaceWith)
            }

            firstCharacter = false
            result += upper ? char.uppercased() : char.lowercased()
        }

        prevChar = char
        idx = nextIdx
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
func toCaseCamelLike(_ string: borrowing String, options: CamelOptions) -> String {
    var newWord = options.newWord
    var firstWord = options.firstWord
    var lastChar = options.lastChar
    var foundRealChar = false
    var result = ""
    result.reserveCapacity(string.count)

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
