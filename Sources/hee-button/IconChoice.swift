/// The selectable menu-bar icons. `rawValue` is the bundled PNG base name
/// (a matching `<name>@2x.png` is expected alongside it).
enum IconChoice: String, CaseIterable {
    case button = "button"
    case simple = "he-simple"
    case simpleBlue = "hee-simple-blue"

    var title: String {
        switch self {
        case .button: return "Button (original)"
        case .simple: return "Simple"
        case .simpleBlue: return "Simple (Blue)"
        }
    }
}
