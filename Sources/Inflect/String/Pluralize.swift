import Foundation

// MARK: - Rule type

/// A single pluralisation rule: a compiled regex and the string to append
/// to capture group 1 when the regex matches.
private struct PluralRule {
    let regex: NSRegularExpression
    let replacement: String

    init(_ pattern: String, _ replacement: String) {
        self.regex = try! NSRegularExpression(pattern: pattern, options: [])
        self.replacement = replacement
    }
}

// MARK: - Rule table

/// 24 pluralisation rules ported directly from the Rust Inflector library.
///
/// Rules are stored in low-to-high priority order and applied in **reverse**
/// (highest priority last), mirroring `RULES.iter().rev()` in Rust.
/// Each rule's regex must have at least one capture group; group 1 is the
/// stem that `replacement` is appended to.
private let pluralRules: [PluralRule] = [
    PluralRule(#"(\w*)s$"#, "s"),
    PluralRule(#"(\w*([^aeiou]ese))$"#, ""),
    PluralRule(#"(\w*(ax|test))is$"#, "es"),
    PluralRule(#"(\w*(alias|[^aou]us|tlas|gas|ris))$"#, "es"),
    PluralRule(#"(\w*(e[mn]u))s?$"#, "s"),
    PluralRule(#"(\w*([^l]ias|[aeiou]las|[emjzr]as|[iu]am))$"#, ""),
    PluralRule(#"(\w*(alumn|syllab|octop|vir|radi|nucle|fung|cact|stimul|termin|bacill|foc|uter|loc|strat))(?:us|i)$"#, "i"),
    PluralRule(#"(\w*(alumn|alg|vertebr))(?:a|ae)$"#, "ae"),
    PluralRule(#"(\w*(seraph|cherub))(?:im)?$"#, "im"),
    PluralRule(#"(\w*(her|at|gr))o$"#, "oes"),
    PluralRule(#"(\w*(agend|addend|millenni|dat|extrem|bacteri|desiderat|strat|candelabr|errat|ov|symposi|curricul|automat|quor))(?:a|um)$"#, "a"),
    PluralRule(#"(\w*(apheli|hyperbat|periheli|asyndet|noumen|phenomen|criteri|organ|prolegomen|hedr|automat))(?:a|on)$"#, "a"),
    PluralRule(#"(\w*)sis$"#, "ses"),
    PluralRule(#"(\w*(kni|wi|li))fe$"#, "ves"),
    PluralRule(#"(\w*(ar|l|ea|eo|oa|hoo))f$"#, "ves"),
    PluralRule(#"(\w*([^aeiouy]|qu))y$"#, "ies"),
    PluralRule(#"(\w*([^ch][ieo][ln]))ey$"#, "ies"),
    PluralRule(#"(\w*(x|ch|ss|sh|zz)es)$"#, ""),
    PluralRule(#"(\w*(x|ch|ss|sh|zz))$"#, "es"),
    PluralRule(#"(\w*(matr|cod|mur|sil|vert|ind|append))(?:ix|ex)$"#, "ices"),
    PluralRule(#"(\w*(m|l)(?:ice|ouse))$"#, "ice"),
    PluralRule(#"(\w*(pe)(?:rson|ople))$"#, "ople"),
    PluralRule(#"(\w*(child))(?:ren)?$"#, "ren"),
    PluralRule(#"(\w*eaux)$"#, ""),
]

// MARK: - Special cases

/// Irregular plurals handled before the regex rules.
private let pluralSpecialCases: [String: String] = [
    "ox": "oxen",
    "man": "men",
    "woman": "women",
    "die": "dice",
    "yes": "yeses",
    "foot": "feet",
    "eave": "eaves",
    "goose": "geese",
    "tooth": "teeth",
    "quiz": "quizzes",
]

// MARK: - Public function

/// Converts an English noun to its plural form.
///
/// Uncountable nouns (see `uncountableWords`) are returned unchanged.
/// Irregular forms are handled via a lookup table before the regex rules are tried.
/// If no rule matches, `"s"` is appended as a fallback.
func toPlural(_ string: String) -> String {
    // Mass nouns are invariant.
    guard !uncountableWords.contains(string) else { return string }

    // Handle well-known irregulars first.
    if let special = pluralSpecialCases[string] { return special }

    let nsString = string as NSString
    let range = NSRange(location: 0, length: nsString.length)

    // Apply rules in reverse (highest-priority rule wins).
    for rule in pluralRules.reversed() {
        guard let match = rule.regex.firstMatch(in: string, options: [], range: range) else { continue }

        let g1 = match.range(at: 1)
        guard g1.location != NSNotFound else { continue }

        // Append replacement to the stem captured by group 1.
        return nsString.substring(with: g1) + rule.replacement
    }

    // Fallback: simply append "s".
    return string + "s"
}
