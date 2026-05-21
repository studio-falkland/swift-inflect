/// Splits `string` on every `"::"` occurrence and returns the components.
///
/// A pure-Swift alternative to `Foundation.components(separatedBy:)` that
/// carries no platform availability requirements.
/// Examples: `"Foo::Bar"` → `["Foo", "Bar"]`, `"A::B::C"` → `["A", "B", "C"]`
func splitOnDoubleColon(_ string: String) -> [String] {
    var parts: [String] = []
    var current = ""
    let chars = Array(string)
    var i = 0

    while i < chars.count {
        if chars[i] == ":", i + 1 < chars.count, chars[i + 1] == ":" {
            // Found "::": flush current component and skip both colons.
            parts.append(current)
            current = ""
            i += 2
        } else {
            current.append(chars[i])
            i += 1
        }
    }

    parts.append(current)
    return parts
}
