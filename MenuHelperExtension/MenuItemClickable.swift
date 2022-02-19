//
//  MenuItemClickable.swift
//  MenuHelperExtension
//
//  Created by Kyle on 2021/10/9.
//

import AppKit
import Foundation
import os.log

private let logger = Logger(subsystem: subsystem, category: "menu_click")

protocol MenuItemClickable {
    func menuClick(with urls: [URL])
}

extension AppMenuItem: MenuItemClickable {
    func menuClick(with urls: [URL]) {
        let config = NSWorkspace.OpenConfiguration()
        config.promptsUserIfNeeded = true
        Task {
            do {
                let application = try await NSWorkspace.shared.open(urls, withApplicationAt: url, configuration: config)
                if let path = application.bundleURL?.path,
                   let identifier = application.bundleIdentifier,
                   let date = application.launchDate {
                    logger.notice("Success: open \(identifier, privacy: .public) app at \(path, privacy: .public) in \(date, privacy: .public)")
                }
            } catch {
                guard let error = error as? CocoaError,
                      let underlyingError = error.userInfo["NSUnderlyingError"] as? NSError else { return }
                logger.error("Error: \(error.localizedDescription)")
                Task { @MainActor in
                    if underlyingError.code == -10820 {
                        let alert = NSAlert(error: error)
                        alert.addButton(withTitle: String(localized: "OK", comment: "OK button"))
                        alert.addButton(withTitle: String(localized: "Remove", comment: "Remove app button"))
                        let response = await alert.run()
                        logger.notice("NSAlert response result \(response.rawValue)")
                        switch response {
                        case .alertFirstButtonReturn:
                            logger.notice("Dismiss error with OK")
                        case .alertSecondButtonReturn:
                            logger.notice("Dismiss error with Remove app")
                            if let index = menuStore.appItems.firstIndex(of: self) {
                                menuStore.deleteAppItems(offsets: IndexSet(integer: index))
                            }
                        default:
                            break
                        }
                    } else {
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = true
                        panel.allowedContentTypes = [.folder]
                        panel.canChooseDirectories = true
                        panel.directoryURL = URL(fileURLWithPath: urls[0].path)
                        let response = await panel.begin()
                        logger.notice("NSOpenPanel response result \(response.rawValue)")
                        if response == .OK {
                            folderStore.appendItems(panel.urls.map { BookmarkFolderItem($0) })
                        }
                    }
                }
            }
        }
    }
}

extension ActionMenuItem: MenuItemClickable {
    static let actions: [([URL]) -> [Bool]] = [
        { urls in
            let board = NSPasteboard.general
            board.clearContents()
            return [
                board.setString(
                    urls.map(\.path)
                        .map {
                            let option = UserDefaults.group.copyPathOption
                            switch option {
                            case .origin:
                                return $0
                            case .escape:
                                return $0.replacingOccurrences(of: " ", with: #"\ "#)
                            case .quoto:
                                return "\"\($0)\""
                            }
                        }
                        .joined(separator: UserDefaults.group.copyPathSeparator), forType: .string)
            ]
        },
        { urls in
            urls.map { url in
                NSWorkspace.shared.selectFile(url.deletingLastPathComponent().path, inFileViewerRootedAtPath: "")
            }
        },
        { urls in
            urls.map { url in
                let name = UserDefaults.group.newFileName
                let fileExtension = UserDefaults.group.newFileExtension.rawValue
                let manager = FileManager.default
                let target: URL
                if manager.directoryExists(atPath: url.path) {
                    target = url
                        .appendingPathComponent(name)
                        .appendingPathExtension(fileExtension)
                } else {
                    target = url
                        .deletingLastPathComponent()
                        .appendingPathComponent(name)
                        .appendingPathExtension(fileExtension)
                }
                logger.notice("Trying to create empty file at \(target.path, privacy: .public)")
                let success = FileManager.default.createFile(atPath: target.path, contents: Data(), attributes: nil)
                return success
            }

        },
    ]

    func menuClick(with urls: [URL]) {
        for (index, result) in ActionMenuItem.actions[actionIndex](urls).enumerated() {
            logger.notice("Result of \(name) in \(urls[index], privacy: .public) is \(result)")
        }
    }
}

private extension FileManager {
    func directoryExists(atPath path: String) -> Bool {
        fileExists(atPath: path, isDirectory: true)
    }

    func fileExists(atPath path: String, isDirectory: Bool) -> Bool {
        var isDirectoryBool = ObjCBool(isDirectory)
        let exists = fileExists(atPath: path, isDirectory: &isDirectoryBool)
        return exists && (isDirectoryBool.boolValue == isDirectory)
    }
}

private extension NSAlert {
    /**
     Workaround to allow using `NSAlert` in a `Task`.

     [FB9857161](https://github.com/feedback-assistant/reports/issues/288)
     */
    @MainActor
    @discardableResult
    func run() async -> NSApplication.ModalResponse {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async { [self] in
                continuation.resume(returning: runModal())
            }
        }
    }
}
