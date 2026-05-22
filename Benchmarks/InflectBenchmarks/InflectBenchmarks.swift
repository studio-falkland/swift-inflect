import Benchmark
import Inflect

// MARK: - Shared test inputs
//
// These are module-level immutable constants (Sendable value types), safe to
// access from any concurrency domain under Swift 6 strict concurrency.

/// Inputs that are already in snake_case.
let snakeCaseInputs: [String] = [
    "foo",
    "foo_bar",
    "some_long_identifier_name",
    "http_response_code",
    "user_account_settings_id",
]

/// Inputs that are already in camelCase.
let camelCaseInputs: [String] = [
    "foo",
    "fooBar",
    "someVeryLongIdentifierName",
    "httpResponseCode",
    "userAccountSettingsId",
]

/// Inputs that are already in PascalCase.
let pascalCaseInputs: [String] = [
    "Foo",
    "FooBar",
    "SomeVeryLongIdentifierName",
    "HttpResponseCode",
    "UserAccountSettingsId",
]

/// Inputs that are already in SCREAMING_SNAKE_CASE.
let screamingSnakeCaseInputs: [String] = [
    "FOO",
    "FOO_BAR",
    "SOME_LONG_IDENTIFIER_NAME",
    "HTTP_RESPONSE_CODE",
    "USER_ACCOUNT_SETTINGS_ID",
]

/// Inputs that are already in kebab-case.
let kebabCaseInputs: [String] = [
    "foo",
    "foo-bar",
    "some-long-identifier-name",
    "http-response-code",
    "user-account-settings-id",
]

/// Singular English nouns covering various pluralisation rule paths
/// (regular, irregular, uncountable, -f→-ves, -y→-ies, etc.).
let singularWordInputs: [String] = [
    "crate",
    "ox",
    "box",
    "woman",
    "geometry",
    "knife",
    "axis",
    "elf",
    "yoga",
    "test",
]

/// Plural English nouns corresponding to the entries above.
let pluralWordInputs: [String] = [
    "crates",
    "oxen",
    "boxes",
    "women",
    "geometries",
    "knives",
    "axes",
    "elves",
    "yoga",
    "tests",
]

/// Numeric strings covering 1st/2nd/3rd/th suffixes and the -11th/-12th/-13th
/// edge cases.
let ordinalStringInputs: [String] = [
    "0", "1", "2", "3", "4",
    "11", "12", "13",
    "21", "22", "23",
    "101", "12001", "12002", "12003",
]

/// Already-ordinalised strings for deordinalize benchmarks.
let deordinalStringInputs: [String] = [
    "0th", "1st", "2nd", "3rd", "4th",
    "11th", "12th", "13th",
    "21st", "22nd", "23rd",
    "101st", "12001st", "12002nd", "12003rd",
]

/// Module-path strings exercising the `::` separator split.
let modulePathInputs: [String] = [
    "Foo",
    "Foo::Bar",
    "Foo::Bar::Baz",
    "App::Models::User",
    "App::Controllers::Api::V1::UsersController",
]

// MARK: - Benchmarks

let benchmarks: @Sendable () -> Void = {

    // =========================================================================
    // MARK: Case conversions — to*
    // =========================================================================

    Benchmark("toCamelCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in snakeCaseInputs {
                blackHole(input.toCamelCase())
            }
        }
    }

    Benchmark("toPascalCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in snakeCaseInputs {
                blackHole(input.toPascalCase())
            }
        }
    }

    Benchmark("toSnakeCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.toSnakeCase())
            }
        }
    }

    Benchmark("toScreamingSnakeCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.toScreamingSnakeCase())
            }
        }
    }

    Benchmark("toKebabCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.toKebabCase())
            }
        }
    }

    Benchmark("toTrainCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.toTrainCase())
            }
        }
    }

    Benchmark("toSentenceCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.toSentenceCase())
            }
        }
    }

    Benchmark("toTitleCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.toTitleCase())
            }
        }
    }

    // ClassCase singularises the last word, so feed snake_case (same as
    // toCamelCase inputs) to exercise the plural-rule path too.
    Benchmark("toClassCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in snakeCaseInputs {
                blackHole(input.toClassCase())
            }
        }
    }

    // TableCase pluralises the last word; camelCase inputs hit the conversion
    // + plural code path.
    Benchmark("toTableCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.toTableCase())
            }
        }
    }

    // =========================================================================
    // MARK: Case predicates — is*
    // =========================================================================

    Benchmark("isCamelCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.isCamelCase)
            }
        }
    }

    Benchmark("isPascalCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in pascalCaseInputs {
                blackHole(input.isPascalCase)
            }
        }
    }

    Benchmark("isSnakeCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in snakeCaseInputs {
                blackHole(input.isSnakeCase)
            }
        }
    }

    Benchmark("isScreamingSnakeCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in screamingSnakeCaseInputs {
                blackHole(input.isScreamingSnakeCase)
            }
        }
    }

    Benchmark("isKebabCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in kebabCaseInputs {
                blackHole(input.isKebabCase)
            }
        }
    }

    Benchmark("isTrainCase") { benchmark in
        for _ in benchmark.scaledIterations {
            // Mix of true (Train-Case) and false (kebab-case) inputs.
            for input in kebabCaseInputs {
                blackHole(input.isTrainCase)
            }
            for input in pascalCaseInputs {
                blackHole(input.isTrainCase)
            }
        }
    }

    Benchmark("isSentenceCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in camelCaseInputs {
                blackHole(input.isSentenceCase)
            }
        }
    }

    Benchmark("isTitleCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in pascalCaseInputs {
                blackHole(input.isTitleCase)
            }
        }
    }

    Benchmark("isClassCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in pascalCaseInputs {
                blackHole(input.isClassCase)
            }
        }
    }

    Benchmark("isTableCase") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in snakeCaseInputs {
                blackHole(input.isTableCase)
            }
        }
    }

    // =========================================================================
    // MARK: Ordinalize / Deordinalize
    // =========================================================================

    Benchmark("ordinalize (String)") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in ordinalStringInputs {
                blackHole(input.ordinalized())
            }
        }
    }

    Benchmark("deordinalize (String)") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in deordinalStringInputs {
                blackHole(input.deordinalized())
            }
        }
    }

    Benchmark("ordinalize (Int)") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole((0 as Int).ordinalized())
            blackHole((1 as Int).ordinalized())
            blackHole((2 as Int).ordinalized())
            blackHole((3 as Int).ordinalized())
            blackHole((11 as Int).ordinalized())
            blackHole((12 as Int).ordinalized())
            blackHole((13 as Int).ordinalized())
            blackHole((21 as Int).ordinalized())
            blackHole((12_003 as Int).ordinalized())
        }
    }

    Benchmark("ordinalize (Double)") { benchmark in
        for _ in benchmark.scaledIterations {
            blackHole((1.0 as Double).ordinalized())
            blackHole((2.0 as Double).ordinalized())
            blackHole((11.0 as Double).ordinalized())
            blackHole((21.5 as Double).ordinalized())  // decimal → passthrough
        }
    }

    // =========================================================================
    // MARK: Pluralize / Singularize
    // =========================================================================

    Benchmark("pluralize") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in singularWordInputs {
                blackHole(input.pluralized())
            }
        }
    }

    Benchmark("singularize") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in pluralWordInputs {
                blackHole(input.singularized())
            }
        }
    }

    // =========================================================================
    // MARK: Module path utilities
    // =========================================================================

    Benchmark("demodulize") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in modulePathInputs {
                blackHole(input.demodulized())
            }
        }
    }

    Benchmark("deconstantize") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in modulePathInputs {
                blackHole(input.deconstantized())
            }
        }
    }

    // =========================================================================
    // MARK: Foreign key
    // =========================================================================

    Benchmark("toForeignKey") { benchmark in
        for _ in benchmark.scaledIterations {
            for input in modulePathInputs {
                blackHole(input.toForeignKey())
            }
        }
    }

    Benchmark("isForeignKey") { benchmark in
        for _ in benchmark.scaledIterations {
            // Mix of valid and invalid foreign key strings.
            blackHole("bar_id".isForeignKey)
            blackHole("foo_bar_id".isForeignKey)
            blackHole("user_account_id".isForeignKey)
            blackHole("bar".isForeignKey)          // false — no _id suffix
            blackHole("fooBar".isForeignKey)       // false — camelCase
        }
    }
}
