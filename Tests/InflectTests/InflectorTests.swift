import Testing
@testable import Inflect

// MARK: - camelCase

@Suite("CamelCase") struct CamelCaseTests {

    /// "foo_bar" → "fooBar"
    @Test func toCamelCase() { #expect("foo_bar".toCamelCase() == "fooBar") }

    /// Already camelCase → true
    @Test func isCamelCase() { #expect("fooBar".isCamelCase == true) }

    /// snake_case is not camelCase
    @Test func isNotCamelCase() { #expect("foo_bar".isCamelCase == false) }

    // Rust test suite includes both str_tests and string_tests; in Swift there is
    // only one String type, so we verify with an explicit String literal too.

    @Test func toCamelCaseStr() { #expect("foo_bar".toCamelCase() == "fooBar") }
    @Test func isCamelCaseStr() { #expect("fooBar".isCamelCase == true) }
    @Test func isNotCamelCaseStr() { #expect("foo_bar".isCamelCase == false) }
}

// MARK: - SCREAMING_SNAKE_CASE

@Suite("ScreamingSnakeCase") struct ScreamingSnakeCaseTests {

    /// "fooBar" → "FOO_BAR"
    @Test func toScreamingSnake() { #expect("fooBar".toScreamingSnakeCase() == "FOO_BAR") }

    @Test func isScreamingSnake() { #expect("FOO_BAR".isScreamingSnakeCase == true) }
    @Test func isNotScreamingSnake() { #expect("foo_bar".isScreamingSnakeCase == false) }
}

// MARK: - snake_case

@Suite("SnakeCase") struct SnakeCaseTests {

    /// "fooBar" → "foo_bar"
    @Test func toSnakeCase() { #expect("fooBar".toSnakeCase() == "foo_bar") }

    @Test func isSnakeCase() { #expect("foo_bar".isSnakeCase == true) }
    @Test func isNotSnakeCase() { #expect("fooBar".isSnakeCase == false) }
}

// MARK: - kebab-case

@Suite("KebabCase") struct KebabCaseTests {

    /// "fooBar" → "foo-bar"
    @Test func toKebabCase() { #expect("fooBar".toKebabCase() == "foo-bar") }

    @Test func isKebabCase() { #expect("foo-bar".isKebabCase == true) }
    @Test func isNotKebabCase() { #expect("fooBar".isKebabCase == false) }
}

// MARK: - Train-Case

@Suite("TrainCase") struct TrainCaseTests {

    /// "fooBar" → "Foo-Bar"
    @Test func toTrainCase() { #expect("fooBar".toTrainCase() == "Foo-Bar") }

    @Test func isTrainCase() { #expect("Foo-Bar".isTrainCase == true) }

    /// "FOO-Bar" is not valid Train-Case (first segment is not title-cased)
    @Test func isNotTrainCase() { #expect("FOO-Bar".isTrainCase == false) }

    /// Rust string_tests use a different negative input: "foo-Bar"
    @Test func isNotTrainCaseAlt() { #expect("foo-Bar".isTrainCase == false) }
}

// MARK: - Sentence case

@Suite("SentenceCase") struct SentenceCaseTests {

    /// "fooBar" → "Foo bar"
    @Test func toSentenceCase() { #expect("fooBar".toSentenceCase() == "Foo bar") }

    @Test func isSentenceCase() { #expect("Foo bar".isSentenceCase == true) }
    @Test func isNotSentenceCase() { #expect("foo_bar".isSentenceCase == false) }

    /// Rust string_tests use a different negative input: "fooBar"
    @Test func isNotSentenceCaseAlt() { #expect("fooBar".isSentenceCase == false) }
}

// MARK: - Title Case

@Suite("TitleCase") struct TitleCaseTests {

    /// "fooBar" → "Foo Bar"
    @Test func toTitleCase() { #expect("fooBar".toTitleCase() == "Foo Bar") }

    @Test func isTitleCase() { #expect("Foo Bar".isTitleCase == true) }
    @Test func isNotTitleCase() { #expect("Foo_Bar".isTitleCase == false) }

    /// Rust string_tests use a different negative input: "fooBar"
    @Test func isNotTitleCaseAlt() { #expect("fooBar".isTitleCase == false) }
}

// MARK: - ClassCase

@Suite("ClassCase") struct ClassCaseTests {

    /// "foo" → "Foo"
    @Test func toClassCase() { #expect("foo".toClassCase() == "Foo") }

    @Test func isClassCase() { #expect("Foo".isClassCase == true) }
    @Test func isNotClassCase() { #expect("foo".isClassCase == false) }

    /// Rust string_tests use a different negative input: "ooBar"
    @Test func isNotClassCaseAlt() { #expect("ooBar".isClassCase == false) }
}

// MARK: - table_case

@Suite("TableCase") struct TableCaseTests {

    /// "fooBar" → "foo_bars"
    @Test func toTableCase() { #expect("fooBar".toTableCase() == "foo_bars") }

    @Test func isTableCase() { #expect("foo_bars".isTableCase == true) }
    @Test func isNotTableCase() { #expect("fooBars".isTableCase == false) }

    /// Rust string_tests use a different negative input: "fooBar"
    @Test func isNotTableCaseAlt() { #expect("fooBar".isTableCase == false) }
}

// MARK: - Ordinalize / Deordinalize

@Suite("Ordinalize") struct OrdinalizeTests {

    // All cases from the Rust ordinalize doc-tests
    @Test func nonNumericPassthrough() { #expect("a".ordinalized() == "a") }
    @Test func decimalPassthrough() { #expect("0.1".ordinalized() == "0.1") }
    @Test func negativeInteger() { #expect("-1".ordinalized() == "-1st") }
    @Test func zero() { #expect("0".ordinalized() == "0th") }
    @Test func one() { #expect("1".ordinalized() == "1st") }
    @Test func two() { #expect("2".ordinalized() == "2nd") }
    @Test func three() { #expect("3".ordinalized() == "3rd") }
    @Test func nine() { #expect("9".ordinalized() == "9th") }
    @Test func twelve() { #expect("12".ordinalized() == "12th") }
    @Test func twelveThousand() { #expect("12000".ordinalized() == "12000th") }
    @Test func twelveThousandOne() { #expect("12001".ordinalized() == "12001st") }
    @Test func twelveThousandTwo() { #expect("12002".ordinalized() == "12002nd") }
    @Test func twelveThousandThree() { #expect("12003".ordinalized() == "12003rd") }
    @Test func twelveThousandFour() { #expect("12004".ordinalized() == "12004th") }

    // All cases from the Rust deordinalize doc-tests
    @Test func deordDecimalPassthrough() { #expect("0.1".deordinalized() == "0.1") }
    @Test func deordNegative() { #expect("-1st".deordinalized() == "-1") }
    @Test func deordZero() { #expect("0th".deordinalized() == "0") }
    @Test func deordOne() { #expect("1st".deordinalized() == "1") }
    @Test func deordTwo() { #expect("2nd".deordinalized() == "2") }
    @Test func deordThree() { #expect("3rd".deordinalized() == "3") }
    @Test func deordNine() { #expect("9th".deordinalized() == "9") }
    @Test func deordTwelve() { #expect("12th".deordinalized() == "12") }
    @Test func deordTwelveThousand() { #expect("12000th".deordinalized() == "12000") }
    @Test func deordTwelveThousandOne() { #expect("12001th".deordinalized() == "12001") }
    @Test func deordTwelveThousandTwo() { #expect("12002nd".deordinalized() == "12002") }
    @Test func deordTwelveThousandThree() { #expect("12003rd".deordinalized() == "12003") }
    @Test func deordTwelveThousandFour() { #expect("12004th".deordinalized() == "12004") }
}

// MARK: - Foreign key

@Suite("ForeignKey") struct ForeignKeyTests {

    /// "Foo::Bar" → "bar_id"
    @Test func toForeignKey() { #expect("Foo::Bar".toForeignKey() == "bar_id") }

    @Test func isForeignKey() { #expect("bar_id".isForeignKey == true) }
    @Test func isNotForeignKey() { #expect("bar".isForeignKey == false) }
}

// MARK: - Pluralize / Singularize

@Suite("PluralSingular") struct PluralSingularTests {

    // Pluralize — from Rust doc-tests and make_tests!
    @Test func pluralizeFooBar() { #expect("foo_bar".pluralized() == "foo_bars") }
    @Test func pluralizeOx() { #expect("ox".pluralized() == "oxen") }
    @Test func pluralizeCrate() { #expect("crate".pluralized() == "crates") }
    @Test func pluralizeBoxes() { #expect("boxes".pluralized() == "boxes") }
    @Test func pluralizeVengeance() { #expect("vengeance".pluralized() == "vengeance") }
    @Test func pluralizeYoga() { #expect("yoga".pluralized() == "yoga") }
    @Test func pluralizeGeometry() { #expect("geometry".pluralized() == "geometries") }
    @Test func pluralizeBox() { #expect("box".pluralized() == "boxes") }
    @Test func pluralizeWoman() { #expect("woman".pluralized() == "women") }
    @Test func pluralizeTest() { #expect("test".pluralized() == "tests") }
    @Test func pluralizeAxis() { #expect("axis".pluralized() == "axes") }
    @Test func pluralizeKnife() { #expect("knife".pluralized() == "knives") }
    @Test func pluralizeAgendum() { #expect("agendum".pluralized() == "agenda") }
    @Test func pluralizeElf() { #expect("elf".pluralized() == "elves") }
    @Test func pluralizeZoology() { #expect("zoology".pluralized() == "zoology") }

    // Singularize — from Rust doc-tests and unit tests
    @Test func singularizeFooBars() { #expect("foo_bars".singularized() == "foo_bar") }
    @Test func singularizeOxen() { #expect("oxen".singularized() == "ox") }
    @Test func singularizeCrates() { #expect("crates".singularized() == "crate") }
    @Test func singularizeBoxes() { #expect("boxes".singularized() == "box") }
    @Test func singularizeVengeance() { #expect("vengeance".singularized() == "vengeance") }
    @Test func singularizeYoga() { #expect("yoga".singularized() == "yoga") }
    @Test func singularizeReplies() { #expect("replies".singularized() == "reply") }
    @Test func singularizeLadies() { #expect("ladies".singularized() == "lady") }
    @Test func singularizeSoliloquies() { #expect("soliloquies".singularized() == "soliloquy") }
    @Test func singularizeGlass() { #expect("glass".singularized() == "glass") }
    @Test func singularizeAccess() { #expect("access".singularized() == "access") }
    @Test func singularizeGlasses() { #expect("glasses".singularized() == "glass") }
    @Test func singularizeWitches() { #expect("witches".singularized() == "witch") }
    @Test func singularizeDishes() { #expect("dishes".singularized() == "dish") }
    @Test func singularizeBacon() { #expect("bacon".singularized() == "bacon") }
}

// MARK: - Demodulize / Deconstantize

@Suite("ModulePath") struct ModulePathTests {

    /// Last component of "Foo::Bar" → "Bar"
    @Test func demodulize() { #expect("Foo::Bar".demodulized() == "Bar") }

    /// Second-to-last component of "Foo::Bar" → "Foo"
    @Test func deconstantize() { #expect("Foo::Bar".deconstantized() == "Foo") }
}

// MARK: - Numeric ordinalize (mirrors Rust's number_tests!)

@Suite("NumericOrdinalize") struct NumericOrdinalizeTests {

    // Signed integers
    @Test func i8() { let v: Int8 = 1; #expect(v.ordinalized() == "1st") }
    @Test func i16() { let v: Int16 = 1; #expect(v.ordinalized() == "1st") }
    @Test func i32() { let v: Int32 = 1; #expect(v.ordinalized() == "1st") }
    @Test func i64() { let v: Int64 = 1; #expect(v.ordinalized() == "1st") }

    // Unsigned integers
    @Test func u8() { let v: UInt8 = 1; #expect(v.ordinalized() == "1st") }
    @Test func u16() { let v: UInt16 = 1; #expect(v.ordinalized() == "1st") }
    @Test func u32() { let v: UInt32 = 1; #expect(v.ordinalized() == "1st") }
    @Test func u64() { let v: UInt64 = 1; #expect(v.ordinalized() == "1st") }

    // Platform-width integers
    @Test func isize() { let v: Int = 1; #expect(v.ordinalized() == "1st") }
    @Test func usize() { let v: UInt = 1; #expect(v.ordinalized() == "1st") }

    // Floating-point — whole-number floats are ordinalised like integers.
    @Test func f32() { let v: Float = 1.0; #expect(v.ordinalized() == "1st") }
    @Test func f64() { let v: Double = 1.0; #expect(v.ordinalized() == "1st") }
}
