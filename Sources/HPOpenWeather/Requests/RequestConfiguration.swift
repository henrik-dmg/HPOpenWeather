import Foundation

public struct RequestConfiguration {

    // MARK: - Nested Types

    public enum Language: String {
        case afrikaans = "af"
        case arabic = "ar"
        case azerbaijani = "az"
        case bulgarian = "bg"
        case catalan = "ca"
        case czech = "cz"
        case danish = "da"
        case german = "de"
        case greek = "el"
        case english = "en"
        case basque = "eu"
        case persian = "fa"
        case finnish = "fi"
        case french = "fr"
        case galician = "gl"
        case hebrew = "he"
        case hindi = "hi"
        case croatian = "hr"
        case hungarian = "hu"
        case indonesian = "id"
        case italian = "it"
        case japanese = "ja"
        case korean = "kr"
        case latvian = "la"
        case lithuanian = "lt"
        case macedonian = "mk"
        case norwegian = "no"
        case dutch = "nl"
        case polish = "pl"
        case portuguese = "pt"
        case portugueseBrasil = "pt_br"
        case romanian = "ro"
        case russian = "ru"
        case swedish = "sv"
        case slovak = "sk"
        case slovenian = "sl"
        case spanish = "es"
        case serbian = "sr"
        case thai = "th"
        case turkish = "tr"
        case ukrainian = "ua"
        case vietnamese = "vi"
        case chineseSimplified = "zh_cn"
        case chineseTraditional = "zh_tw"
        case zulu = "zu"
    }

    public enum Units: String {
        case metric
        case imperial
    }

    // MARK: - Properties

    let apiKey : String?
    let language: Language
    let units: Units

    // MARK: - Init

    public init(language: Language = .english, units: Units = .metric, apiKey: String? = HPOpenWeather.shared.apiKey) {
        self.language = language
        self.units = units
        self.apiKey = apiKey
    }

    public static let `default` = RequestConfiguration()

}
