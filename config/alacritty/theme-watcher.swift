#!/usr/bin/swift

import Foundation

let scriptPath = FileManager.default
    .homeDirectoryForCurrentUser
    .appendingPathComponent(".config/alacritty/alacritty-theme-switcher.sh")
    .path

// Run the script once on start
Process.launchedProcess(launchPath: "/bin/bash", arguments: [scriptPath])

// Listen for appearance changes
DistributedNotificationCenter.default.addObserver(
    forName: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: nil
) { _ in
    Process.launchedProcess(launchPath: "/bin/bash", arguments: [scriptPath])
}

// Keep the script running
RunLoop.main.run()
