/// Strips the ordinal suffix from a numeric string.
///
/// Decimal strings are returned unchanged (e.g. `"0.1"` → `"0.1"`).
/// Checks the last two characters directly instead of iterating an array of
/// suffix strings.
/// Examples: `"1st"` → `"1"`, `"12th"` → `"12"`, `"0.1"` → `"0.1"`
func deordinalize(_ string: String) -> String {
    // Decimal numbers are never ordinalized, so return as-is.
    // Also guard against strings shorter than 2 characters.
    guard !string.contains("."), string.count >= 2 else { return string }

    let twoSuffix = string.suffix(2)
    if twoSuffix == "st" || twoSuffix == "nd" || twoSuffix == "rd" || twoSuffix == "th" {
        return String(string.dropLast(2))
    }

    return string
}
