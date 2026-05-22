/// Converts a numeric string to its ordinal form.
///
/// Rules (matching Rust's `ordinalize`):
/// - Non-numeric last character → return unchanged (already ordinalised or non-numeric)
/// - Numbers ending in 11, 12, 13 → always "th" (e.g. `"112"` → `"112th"`)
/// - Decimal numbers → return unchanged (e.g. `"0.1"` → `"0.1"`)
/// - Otherwise: 1 → "st", 2 → "nd", 3 → "rd", everything else → "th"
func ordinalize(_ string: String) -> String {
    // If the last character is not a digit, the string is already non-numeric.
    guard let last = string.last, last.isNumber else { return string }

    if string.count > 1 {
        // Numbers whose tens digit is 1 (11th, 12th, 13th, 111th, …) always use "th".
        // Access the second-to-last character via index arithmetic.
        let penultimate = string[string.index(string.endIndex, offsetBy: -2)]
        if penultimate == "1" { return string + "th" }

        // Decimal numbers are returned as-is.
        if string.contains(".") { return string }
    }

    switch last {
    case "1": return string + "st"
    case "2": return string + "nd"
    case "3": return string + "rd"
    default:  return string + "th"
    }
}
