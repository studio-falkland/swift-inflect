/// Returns the second-to-last component of a Ruby/Rust module path, converted to ClassCase.
///
/// If `string` contains no `"::"` an empty string is returned.
/// Examples: `"Foo::Bar"` → `"Foo"`, `"Test::Foo::Bar"` → `"Foo"`, `"Bar"` → `""`
func deconstantize(_ string: String) -> String {
    guard string.contains("::") else { return "" }

    let parts = splitOnDoubleColon(string)
    guard parts.count > 1 else { return "" }

    // ClassCase the second-to-last component.
    return toClassCase(parts[parts.count - 2])
}
