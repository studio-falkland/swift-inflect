/// Returns the last component of a Ruby/Rust module path, converted to ClassCase.
///
/// If `string` contains no `"::"` it is returned unchanged.
/// Examples: `"Foo::Bar"` → `"Bar"`, `"Test::Foo::Bar"` → `"Bar"`, `"Bar"` → `"Bar"`
func demodulize(_ string: String) -> String {
    guard string.contains("::") else { return string }

    // ClassCase the last component.
    return toClassCase(splitOnDoubleColon(string).last ?? string)
}
