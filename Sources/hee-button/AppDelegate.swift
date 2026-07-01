import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    // Held strongly; a status item is released (and disappears) if not retained.
    private var statusItem: NSStatusItem!
    private let audioPlayer = AudioPlayer()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        guard let button = statusItem.button else { return }
        button.image = Self.loadIcon()
        button.toolTip = "HeeButton"
        button.target = self
        button.action = #selector(handleClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    /// Loads the colored menu-bar icon from the resource bundle, combining the
    /// 1x/2x bitmaps so it stays crisp on Retina. Rendered at 18pt to leave the
    /// standard menu-bar margin.
    private static func loadIcon() -> NSImage? {
        guard let url1x = Bundle.module.url(forResource: "button", withExtension: "png"),
              let rep1x = NSImageRep(contentsOf: url1x) else {
            return nil
        }
        let image = NSImage(size: NSSize(width: 18, height: 18))
        image.addRepresentation(rep1x)
        if let url2x = Bundle.module.url(forResource: "button@2x", withExtension: "png"),
           let rep2x = NSImageRep(contentsOf: url2x) {
            image.addRepresentation(rep2x)
        }
        image.size = NSSize(width: 18, height: 18)
        image.isTemplate = false // keep the original colors
        return image
    }

    @objc private func handleClick(_ sender: NSStatusBarButton) {
        if NSApp.currentEvent?.type == .rightMouseUp {
            showMenu()
        } else {
            audioPlayer.play()
        }
    }

    private func showMenu() {
        let menu = NSMenu()
        let quit = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)

        // Attach the menu only for this click, then detach so the next
        // left-click fires the play action instead of opening the menu.
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
