/// Splits `string` on every `"::"` occurrence and returns the components.
///
/// Uses index-based iteration to avoid converting the String to an Array of
/// Characters. Examples: `"Foo::Bar"` → `["Foo", "Bar"]`, `"A::B::C"` → `["A", "B", "C"]`
func splitOnDoubleColon(_ string: borrowing String) -> [String] {
    var parts: [String] = []
    var segmentStart = string.startIndex
    var idx = string.startIndex

    while idx < string.endIndex {
        if string[idx] == ":" {
            let next = string.index(after: idx)
            if next < string.endIndex && string[next] == ":" {
                parts.append(String(string[segmentStart..<idx]))
                idx = string.index(after: next)
                segmentStart = idx
                continue
            }
        }
        idx = string.index(after: idx)
    }

    parts.append(String(string[segmentStart...]))
    return parts
}
