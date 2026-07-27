// MARK: - String extension

/// Adds all inflection methods to `String`.
///
/// Every method delegates to a module-level free function so the core logic
/// is independently testable and reusable.
extension String {

    // MARK: Case conversions

    /// Converts to camelCase. e.g. `"foo_bar"` → `"fooBar"`
    public func toCamelCase() -> String { Inflect.toCamelCase(self) }

    /// `true` if the string is already camelCase.
    public var isCamelCase: Bool { Inflect.isCamelCase(self) }

    /// Converts to PascalCase. e.g. `"foo_bar"` → `"FooBar"`
    public func toPascalCase() -> String { Inflect.toPascalCase(self) }

    /// `true` if the string is already PascalCase.
    public var isPascalCase: Bool { Inflect.isPascalCase(self) }

    /// Converts to snake_case. e.g. `"fooBar"` → `"foo_bar"`
    public func toSnakeCase() -> String { Inflect.toSnakeCase(self) }

    /// `true` if the string is already snake_case.
    public var isSnakeCase: Bool { Inflect.isSnakeCase(self) }

    /// Converts to SCREAMING_SNAKE_CASE. e.g. `"fooBar"` → `"FOO_BAR"`
    public func toScreamingSnakeCase() -> String { Inflect.toScreamingSnakeCase(self) }

    /// `true` if the string is already SCREAMING_SNAKE_CASE.
    public var isScreamingSnakeCase: Bool { Inflect.isScreamingSnakeCase(self) }

    /// Converts to kebab-case. e.g. `"fooBar"` → `"foo-bar"`
    public func toKebabCase() -> String { Inflect.toKebabCase(self) }

    /// `true` if the string is already kebab-case.
    public var isKebabCase: Bool { Inflect.isKebabCase(self) }

    /// Converts to Train-Case. e.g. `"fooBar"` → `"Foo-Bar"`
    public func toTrainCase() -> String { Inflect.toTrainCase(self) }

    /// `true` if the string is already Train-Case.
    public var isTrainCase: Bool { Inflect.isTrainCase(self) }

    /// Converts to a URL-safe slug. e.g. `"Hello, World!"` → `"hello-world"`,
    /// `"Café Olé"` → `"cafe-ole"`. Non-alphanumerics are dropped and Latin
    /// diacritics are folded to their ASCII equivalents.
    public func toSlug() -> String { Inflect.toSlug(self) }

    /// `true` if the string is already a valid slug.
    public var isSlug: Bool { Inflect.isSlug(self) }

    /// Converts to Sentence case. e.g. `"fooBar"` → `"Foo bar"`
    public func toSentenceCase() -> String { Inflect.toSentenceCase(self) }

    /// `true` if the string is already Sentence case.
    public var isSentenceCase: Bool { Inflect.isSentenceCase(self) }

    /// Converts to Title Case. e.g. `"fooBar"` → `"Foo Bar"`
    public func toTitleCase() -> String { Inflect.toTitleCase(self) }

    /// `true` if the string is already Title Case.
    public var isTitleCase: Bool { Inflect.isTitleCase(self) }

    /// Converts to ClassCase (singularised PascalCase). e.g. `"foo_bars"` → `"FooBar"`
    public func toClassCase() -> String { Inflect.toClassCase(self) }

    /// `true` if the string is already ClassCase.
    public var isClassCase: Bool { Inflect.isClassCase(self) }

    /// Converts to table_case (pluralised snake_case). e.g. `"fooBar"` → `"foo_bars"`
    public func toTableCase() -> String { Inflect.toTableCase(self) }

    /// `true` if the string is already table_case.
    public var isTableCase: Bool { Inflect.isTableCase(self) }

    // MARK: Numbers

    /// Ordinalises a numeric string. e.g. `"1"` → `"1st"`, `"11"` → `"11th"`
    public func ordinalized() -> String { Inflect.ordinalize(self) }

    /// Strips the ordinal suffix from a numeric string. e.g. `"1st"` → `"1"`
    public func deordinalized() -> String { Inflect.deordinalize(self) }

    // MARK: Suffix

    /// Converts to a foreign key column name. e.g. `"Foo::Bar"` → `"bar_id"`
    public func toForeignKey() -> String { Inflect.toForeignKey(self) }

    /// `true` if the string is already a valid foreign key name.
    public var isForeignKey: Bool { Inflect.isForeignKey(self) }

    // MARK: String utilities

    /// Returns the plural form of the noun. e.g. `"crate"` → `"crates"`
    public func pluralized() -> String { Inflect.toPlural(self) }

    /// Returns the singular form of the noun. e.g. `"crates"` → `"crate"`
    public func singularized() -> String { Inflect.toSingular(self) }

    /// Returns the last component of a module path in ClassCase.
    /// e.g. `"Foo::Bar"` → `"Bar"`
    public func demodulized() -> String { Inflect.demodulize(self) }

    /// Returns the second-to-last component of a module path in ClassCase.
    /// e.g. `"Foo::Bar"` → `"Foo"`
    public func deconstantized() -> String { Inflect.deconstantize(self) }
}

// MARK: - Numeric extensions

extension BinaryInteger {

    /// Ordinalises the integer by converting it to a string first.
    /// e.g. `1` → `"1st"`, `42` → `"42nd"`
    public func ordinalized() -> String {
        Inflect.ordinalize(String(self))
    }
}

extension BinaryFloatingPoint {

    /// Ordinalises the floating-point number.
    ///
    /// Whole-number floats are formatted without a decimal point to match
    /// Rust's `Display` behaviour (`1.0.to_string()` yields `"1"` in Rust).
    /// This ensures `(1.0 as Float).ordinalized()` returns `"1st"` rather
    /// than leaving `"1.0"` unchanged (decimals are not ordinalised).
    public func ordinalized() -> String {
        let d = Double(self)

        // Whole number: use integer representation to avoid the decimal point.
        if d.isFinite && d == d.rounded(.towardZero) {
            return Inflect.ordinalize(String(Int64(d)))
        }

        return Inflect.ordinalize(String(d))
    }
}
