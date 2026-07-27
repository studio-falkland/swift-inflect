import Foundation

// MARK: - Rule type

/// A single singularisation rule: a compiled regex and a replacement template.
/// The template is appended to capture group 1; it may contain `$N`
/// back-references that are expanded against the match's capture groups.
private struct SingularRule {
    let regex: NSRegularExpression
    let replacement: String

    init(_ pattern: String, _ replacement: String) {
        self.regex = try! NSRegularExpression(pattern: pattern, options: [])
        self.replacement = replacement
    }
}

// MARK: - Rule table

/// 27 singularisation rules ported directly from the Rust Inflector library.
///
/// Applied in **reverse** order (highest-priority rule wins), mirroring
/// `RULES.iter().rev()` in Rust.
private let singularRules: [SingularRule] = [
    SingularRule(#"(\w*)s$"#, ""),
    SingularRule(#"(\w*)(ss)$"#, "$2"),
    SingularRule(#"(n)ews$"#, "ews"),
    SingularRule(#"(\w*)(o)es$"#, ""),
    SingularRule(#"(\w*)([ti])a$"#, "um"),
    SingularRule(#"((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$"#, "sis"),
    SingularRule(#"(^analy)(sis|ses)$"#, "sis"),
    SingularRule(#"(\w*)([^f])ves$"#, "fe"),
    SingularRule(#"(\w*)(hive)s$"#, ""),
    SingularRule(#"(\w*)(tive)s$"#, ""),
    SingularRule(#"(\w*)([lr])ves$"#, "f"),
    SingularRule(#"(\w*([^aeiouy]|qu))ies$"#, "y"),
    SingularRule(#"(s)eries$"#, "eries"),
    SingularRule(#"(m)ovies$"#, "ovie"),
    SingularRule(#"(\w*)(x|ch|ss|sh)es$"#, "$2"),
    SingularRule(#"(m|l)ice$"#, "ouse"),
    SingularRule(#"(bus)(es)?$"#, ""),
    SingularRule(#"(shoe)s$"#, ""),
    SingularRule(#"(cris|test)(is|es)$"#, "is"),
    SingularRule(#"^(a)x[ie]s$"#, "xis"),
    SingularRule(#"(octop|vir)(us|i)$"#, "us"),
    SingularRule(#"(alias|status)(es)?$"#, ""),
    SingularRule(#"^(ox)en"#, ""),
    SingularRule(#"(vert|ind)ices$"#, "ex"),
    SingularRule(#"(matr)ices$"#, "ix"),
    SingularRule(#"(quiz)zes$"#, ""),
    SingularRule(#"(database)s$"#, ""),
]

// MARK: - Special cases

/// Irregular singulars handled before the regex rules.
private let singularSpecialCases: [String: String] = [
    "oxen": "ox",
    "boxes": "box",
    "men": "man",
    "women": "woman",
    "dice": "die",
    "yeses": "yes",
    "feet": "foot",
    "eaves": "eave",
    "geese": "goose",
    "teeth": "tooth",
    "quizzes": "quiz",
]

// MARK: - Back-reference expansion

/// Expands `$N` back-references in `template` using the capture groups of `match`.
///
/// For example, given template `"$2"` and a match where group 2 is `"x"`,
/// the result is `"x"`.  Digits immediately following `$` are consumed as the
/// group index; any other characters are passed through verbatim.
///
/// Most replacement templates contain no `$`; the fast-path short-circuits for
/// those (25 of the 27 singularisation rules), avoiding all character iteration.
private func expandTemplate(_ template: String, match: NSTextCheckingResult, in ns: NSString) -> String {
    // Fast path: no back-reference to expand — return the template verbatim.
    guard template.contains("$") else { return template }

    var result = ""
    var idx = template.startIndex

    while idx < template.endIndex {
        let char = template[idx]
        let nextIdx = template.index(after: idx)

        if char == "$", nextIdx < template.endIndex,
           let digit = template[nextIdx].wholeNumberValue {
            // Substitute capture group `digit`.
            let r = match.range(at: digit)
            if r.location != NSNotFound { result += ns.substring(with: r) }
            idx = template.index(after: nextIdx)
        } else {
            result.append(char)
            idx = nextIdx
        }
    }

    return result
}

// MARK: - Public function

/// Converts an English plural noun to its singular form.
///
/// Uncountable nouns are returned unchanged.
/// Irregular forms are resolved via a lookup table before regex rules are tried.
/// If no rule matches, the string is returned as-is.
func toSingular(_ string: String) -> String {
    // Mass nouns are invariant.
    guard !uncountableWords.contains(string) else { return string }

    // Handle well-known irregulars first.
    if let special = singularSpecialCases[string] { return special }

    let ns = string as NSString
    let range = NSRange(location: 0, length: ns.length)

    // Apply rules in reverse (highest-priority rule wins).
    for rule in singularRules.reversed() {
        guard let match = rule.regex.firstMatch(in: string, options: [], range: range) else { continue }

        let g1 = match.range(at: 1)
        guard g1.location != NSNotFound else { continue }

        // Concatenate the stem (group 1) with the expanded replacement template.
        return ns.substring(with: g1) + expandTemplate(rule.replacement, match: match, in: ns)
    }

    // No rule matched: return unchanged.
    return string
}
