//
//  FinderSync+UserDefaults.swift
//  MenuHelperExtension
//
//  Created by Kyle on 2021/10/9.
//

import Foundation
import os.log

private let logger = Logger(subsystem: subsystem, category: "user_defaults")

extension UserDefaults {
    var showContextualMenuForItem: Bool {
        defaults(for: Key.showContextualMenuForItem) ?? true
    }

    var showContextualMenuForContainer: Bool {
        defaults(for: Key.showContextualMenuForContainer) ?? true
    }

    var showContextualMenuForSidebar: Bool {
        defaults(for: Key.showContextualMenuForSidebar) ?? true
    }

    var showToolbarItemMenu: Bool {
        defaults(for: Key.showToolbarItemMenu) ?? true
    }

    var copyPathSeparator: String {
        defaults(for: Key.copyPathSeparator) ?? " "
    }

    var copyPathOption: CopyPathOption {
        let optionRaw = defaults(for: Key.copyPathOption) ?? 0
        return CopyPathOption(rawValue: optionRaw) ?? .origin        
    }

    var newFileName: String {
        defaults(for: Key.newFileName) ?? "Untitled"
    }

    var newFileExtension: NewFileExtension {
        let fileExtensionRaw = defaults(for: Key.newFileExtension) ?? ""
        return NewFileExtension(rawValue: fileExtensionRaw) ?? .none
    }

    private func defaults<T>(for key: String) -> T? {
        if let value = object(forKey: key) as? T {
            return value
        } else {
            logger.info("Missing key for \(key, privacy: .public), using default true value")
            return nil
        }
    }
}
