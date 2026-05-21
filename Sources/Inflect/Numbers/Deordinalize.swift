/// Strips the ordinal suffix from a numeric string.
///
/// Decimal strings are returned unchanged (e.g. `"0.1"` → `"0.1"`).
/// Otherwise the first matching suffix `"st"`, `"nd"`, `"rd"`, or `"th"`
/// is removed from the end.
/// Examples: `"1st"` → `"1"`, `"12th"` → `"12"`, `"0.1"` → `"0.1"`
func deordinalize(_ string: String) -> String {
    // Decimal numbers are never ordinalized, so return as-is.
    guard !string.contains(".") else { return string }

    // Try each suffix in precedence order; remove the first one that matches.
    for suffix in ["st", "nd", "rd", "th"] {
        if string.hasSuffix(suffix) {
            return String(string.dropLast(suffix.count))
        }
    }

    return string
}
