#!/usr/bin/xcrun --sdk macosx swift-sh
import AnyLint // @Flinesoft

try Lint.logSummaryAndExit(arguments: CommandLine.arguments) {

    // MARK: - Space after class


    try Lint.checkFileContents(
        checkInfo: "SpaceAfterClass: Empty line required after class declarations.",
        regex: #"^((?:open |internal |private |public )?(?:final )?class[^\n]+\{\n)(?!\s*\n)"#,
        matchingExamples: ["class MyClass {\n  let", "public final class MyClass {\n  let"],
        nonMatchingExamples: ["class MyClass {\n\n  let", "public final class MyClass {\n\n  let"],
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"],
        autoCorrectReplacement: "$1\n",
        autoCorrectExamples: [
            ["before": "class MyClass {\n  let",
             "after": "class MyClass {\n\n  let"]
        ]
    )

    // MARK: - Space after mark

    try Lint.checkFileContents(
        checkInfo: "SpaceAfterMark: Empty line required after MARK line.",
        regex: #"^(.*MARK:[^\n]+\n)(?!\s*\n)"#,
        matchingExamples: ["//MARK: - Something\n Something"],
        nonMatchingExamples: ["//MARK: - Something\n\n"],
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"],
        autoCorrectReplacement: "$1\n$2",
        autoCorrectExamples: [
                  ["before": "//MARK: - Something\n Something", "after": "//MARK: - Something\n\n Something"]
        ]
    )

    // MARK: - Space before mark

    try Lint.checkFileContents(
        checkInfo: "SpaceBeforeMark: Empty line required before MARK line.",
        regex: #"^(?<!\s\n)^(.*\/\/\s*MARK)"#,
        matchingExamples: ["class {\n //MARK: - Something"],
        nonMatchingExamples: ["class {\n\n //MARK: - Something\n\n"],
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"],
        autoCorrectReplacement: "\n$1",
        autoCorrectExamples: [
                  ["before": "class {\n //MARK: - Something", "after": "class {\n\n //MARK: - Something"]
        ]
    )

    // MARK: - Space after super call

    try Lint.checkFileContents(
        checkInfo: "SpaceAfterSuper: Empty line required after super call in override function",
        regex: #"(^.*(?:super\.){1}.+\){1}\n)(?!(\s*\n+)|(.*\}))"#,
        matchingExamples: ["super.overridingFunc()\nefaefaf"],
        nonMatchingExamples: ["super.overridingFunc()\n\nfefafeafa"],
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"],
        autoCorrectReplacement: "$1\n",
        autoCorrectExamples: [
                  ["before": "super.overridingFunc()\nefaefaf", "after": "super.overridingFunc()\n\nefaefaf"]
        ]
    )

    // MARK: - Plural Marks

    try Lint.checkFileContents(
        checkInfo: "Plural mark: Marks should be written in plural form",
        regex: #"(^.*MARK: - (?:(?:Outlet)|(?:Constant)|(?:Variable)))$"#,
        matchingExamples: ["    MARK: - Outlet"],
        nonMatchingExamples: ["    MARK: - Outlets"],
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"],
        autoCorrectReplacement: "$1s",
        autoCorrectExamples: [
                  ["before": "MARK: - Outlet", "after": "MARK: - Outlets"]
        ]
    )

    // MARK: - Space in enum\struct

    let spaceInEnumStructMatchingExamples =
        """
            public enum YouTubePlayerState: String {
                case Unstarted = "-1"
                case Ended = "0"
                case Playing = "1"
                case Paused = "2"
                case Buffering = "3"
                case Queued = "4"
            }
        """

    let spaceInEnumStructNonMatchingExamples =
        """
            public enum YouTubePlayerState: String {

                case Unstarted = "-1"
                case Ended = "0"
                case Playing = "1"
                case Paused = "2"
                case Buffering = "3"
                case Queued = "4"

            }
        """

    let spaceInEnumStructAutoCorrectExample =
       ["before":
        """
        public enum YouTubePlayerState: String {
            case Unstarted = "-1"
            case Ended = "0"
            case Playing = "1"
            case Paused = "2"
            case Buffering = "3"
            case Queued = "4"
            }
        """,
        "after":
        """
        public enum YouTubePlayerState: String {

            case Unstarted = "-1"
            case Ended = "0"
            case Playing = "1"
            case Paused = "2"
            case Buffering = "3"
            case Queued = "4"

            }
        """
       ] as Array<AutoCorrection>.ArrayLiteralElement

    try Lint.checkFileContents(
        checkInfo: "Space after struct/enum: struct should be followed by a new line",
        regex: #"(^.*(?:(?:enum)|(?:struct)).*\:{0,1}.*\{\n)((?:^.*(?:(?:case)|(?:let)|(?:var)).*\n)*)(^.*\}$)"#,
        matchingExamples: [spaceInEnumStructMatchingExamples],
        nonMatchingExamples: [spaceInEnumStructNonMatchingExamples],
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"],
        autoCorrectReplacement: "$1\n$2\n$3",
        autoCorrectExamples: [spaceInEnumStructAutoCorrectExample]
    )

    // MARK: - Explicit init

    try Lint.checkFileContents(
        checkInfo: "ExplicitInit@warning: Class() is preferable to .init()",
        regex: #"^.*\.init\("#,
        matchingExamples: ["      var = .init(params)"],
        nonMatchingExamples: [" var = Class(params)"],
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"]
    )

    // MARK: - Implicit type

    try Lint.checkFileContents(
        checkInfo: "Implicit type@warning: Type is already implicit from value assigned",
        regex: #"^.+(var|let){1}.+:.+=.+"#,
        matchingExamples: ["   private var pageElementsControllers: [UIViewController] = []"],
        nonMatchingExamples: [" private var pageElementsControllers = [UIViewController]()"],
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"]
    )

    // MARK: - Empty TODOS

    try Lint.checkFileContents(
        checkInfo: "EmptyTodo: TODO comments should not be empty.",
        regex: #"// TODO: *\n"#,
        includeFilters: [#".*\.swift"#],
        excludeFilters: ["Resources", "Pods", "lint.swift"]
    )

}
