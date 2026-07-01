import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    // Held strongly; a status item is released (and disappears) if not retained.
    private var statusItem: NSStatusItem!
    private let audioPlayer = AudioPlayer()

    // Persisted preferences.
    private let defaults = UserDefaults.standard
    private static let iconKey = "iconChoice"
    private static let volumeKey = "volumeLevel" // 1...10

    private var iconChoice: IconChoice = .simpleBlue
    private var volumeLevel = 5 // 1...10 (default 50%), applied as volume = level / 10

    func applicationDidFinishLaunching(_ notification: Notification) {
        restorePreferences()
        audioPlayer.volume = Float(volumeLevel) / 10.0

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        guard let button = statusItem.button else { return }
        button.toolTip = "HeeButton"
        button.target = self
        button.action = #selector(handleClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        updateIconImage()
    }

    private func restorePreferences() {
        if let raw = defaults.string(forKey: Self.iconKey),
           let saved = IconChoice(rawValue: raw) {
            iconChoice = saved
        }
        let savedVolume = defaults.integer(forKey: Self.volumeKey) // 0 when unset
        if (1...10).contains(savedVolume) {
            volumeLevel = savedVolume
        }
    }

    // MARK: - Icon

    private func updateIconImage() {
        statusItem.button?.image = Self.loadIcon(named: iconChoice.rawValue)
    }

    /// Loads a menu-bar icon from the resource bundle, combining the 1x/2x
    /// bitmaps so it stays crisp on Retina. Rendered at 18pt to leave the
    /// standard menu-bar margin.
    private static func loadIcon(named name: String) -> NSImage? {
        guard let url1x = Bundle.main.url(forResource: name, withExtension: "png"),
              let rep1x = NSImageRep(contentsOf: url1x) else {
            return nil
        }
        let image = NSImage(size: NSSize(width: 18, height: 18))
        image.addRepresentation(rep1x)
        if let url2x = Bundle.main.url(forResource: "\(name)@2x", withExtension: "png"),
           let rep2x = NSImageRep(contentsOf: url2x) {
            image.addRepresentation(rep2x)
        }
        image.size = NSSize(width: 18, height: 18)
        image.isTemplate = false // keep the original colors
        return image
    }

    // MARK: - Clicks

    @objc private func handleClick(_ sender: NSStatusBarButton) {
        if NSApp.currentEvent?.type == .rightMouseUp {
            showMenu()
        } else {
            audioPlayer.play()
        }
    }

    private func showMenu() {
        let menu = NSMenu()

        // Icon picker
        let iconItem = NSMenuItem(title: "Icon", action: nil, keyEquivalent: "")
        let iconMenu = NSMenu()
        for choice in IconChoice.allCases {
            let item = NSMenuItem(title: choice.title,
                                  action: #selector(selectIcon(_:)),
                                  keyEquivalent: "")
            item.target = self
            item.representedObject = choice.rawValue
            item.state = (choice == iconChoice) ? .on : .off
            iconMenu.addItem(item)
        }
        iconItem.submenu = iconMenu
        menu.addItem(iconItem)

        // Volume picker (10 steps)
        let volumeItem = NSMenuItem(title: "Volume", action: nil, keyEquivalent: "")
        let volumeMenu = NSMenu()
        for level in 1...10 {
            let item = NSMenuItem(title: "\(level * 10)%",
                                  action: #selector(selectVolume(_:)),
                                  keyEquivalent: "")
            item.target = self
            item.tag = level
            item.state = (level == volumeLevel) ? .on : .off
            volumeMenu.addItem(item)
        }
        volumeItem.submenu = volumeMenu
        menu.addItem(volumeItem)

        menu.addItem(.separator())
        let quit = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)

        // Attach the menu only for this click, then detach so the next
        // left-click fires the play action instead of opening the menu.
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    // MARK: - Menu actions

    @objc private func selectIcon(_ sender: NSMenuItem) {
        guard let raw = sender.representedObject as? String,
              let choice = IconChoice(rawValue: raw) else { return }
        iconChoice = choice
        defaults.set(raw, forKey: Self.iconKey)
        updateIconImage()
    }

    @objc private func selectVolume(_ sender: NSMenuItem) {
        let level = sender.tag
        guard (1...10).contains(level) else { return }
        volumeLevel = level
        defaults.set(level, forKey: Self.volumeKey)
        audioPlayer.volume = Float(level) / 10.0
        audioPlayer.play() // preview the new level
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
