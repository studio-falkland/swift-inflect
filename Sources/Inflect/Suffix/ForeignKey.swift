/// Converts `string` to a foreign key column name.
///
/// If `string` contains `"::"` (a Ruby/Rust module path), only the last
/// component is used. The component is then snake_cased and `"_id"` is
/// appended unless it is already present.
/// Examples: `"Foo::Bar"` → `"bar_id"`, `"FooBar"` → `"foo_bar_id"`
func toForeignKey(_ string: String) -> String {
    // Strip module path prefix — take only the last component.
    let base = string.contains("::") ? splitOnDoubleColon(string).last ?? string : string

    let snaked = toSnakeCase(base)

    // Avoid double-appending "_id" if already present.
    return snaked.hasSuffix("_id") ? snaked : snaked + "_id"
}

/// Returns `true` when `string` is already a valid foreign key name.
func isForeignKey(_ string: borrowing String) -> Bool {
    toForeignKey(string) == string
}
