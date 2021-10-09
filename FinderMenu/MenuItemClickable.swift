//
//  MenuItemClickable.swift
//  MenuItemClickable
//
//  Created by Kyle on 2021/10/9.
//

import AppKit
import Foundation

protocol MenuItemClickable {
    func menuClick(with urls: [URL])
}

extension AppMenuItem: MenuItemClickable {
    func menuClick(with urls: [URL]) {
        let config = NSWorkspace.OpenConfiguration()
        config.promptsUserIfNeeded = true
        NSWorkspace.shared.open(urls, withApplicationAt: url, configuration: config) { application, error in
            if let error = error {
                logger.error("Error: \(error.localizedDescription)")
                return
            }
            if let application = application {
                if let path = application.bundleURL?.path,
                   let identifier = application.bundleIdentifier,
                   let date = application.launchDate {
                    logger.notice("Success: open \(identifier, privacy: .public) app at \(path, privacy: .public) in \(date, privacy: .public)")
                }
            }
        }
    }
}

extension ActionMenuItem: MenuItemClickable {
    func menuClick(with urls: [URL]) {
        ActionMenuItem.actions[actionIndex](urls)
    }
}
