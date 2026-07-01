import AppKit

// Menu bar only: no Dock icon, no main window. LSUIElement in Info.plist
// covers the bundled app; setActivationPolicy(.accessory) covers `swift run`.
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
