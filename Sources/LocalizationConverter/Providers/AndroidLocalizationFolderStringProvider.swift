//
//  AndroidLocalizationFolderStringProvider.swift
//
//  Created by Sébastien Duperron on 26/09/2016.
//  Copyright © 2016 Sébastien Duperron
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import Foundation

protocol FileProvider {
    func contentsOfDirectory(atPath: String) throws -> [String]
}

extension FileManager: FileProvider {}

struct AndroidLocalizationFolderStringProvider {
    fileprivate let languageToFilePath: [Language:String]

    init(folderPath: String, fileProvider: FileProvider = FileManager()) throws {
        let staticType = type(of: self)
        let folders = try staticType.listFolders(atPath: folderPath, fileProvider: fileProvider)
        self.languageToFilePath = staticType.listLanguages(from: folders, at: folderPath)
    }

    private static func listFolders(atPath path: String, fileProvider: FileProvider) throws -> [String] {
        return try fileProvider.contentsOfDirectory(atPath: path)
    }

    private static func listLanguages(from folders: [String], at folderPath: String) -> [Language:String] {
        let languageToFilePath = folders.reduce([Language:String]()) { (values, folderName) in
            guard let language = language(fromFolderName: folderName) else { return values }
            let filePath = folderPath
                .appending(pathComponent: folderName)
                .appending(pathComponent: "strings.xml")
            var output = values
            output[language] = filePath
            return output
        }
        return languageToFilePath
    }

    private static func language(fromFolderName folderName: String) -> Language? {
        if folderName == "values" { return .base }
        let prefix = "values-"
        guard folderName.hasPrefix(prefix) else { return nil }
        let languageName = folderName.replacingOccurrences(of: prefix, with: "")
        return .named(languageName)
    }
}

extension AndroidLocalizationFolderStringProvider: LocalizationStringProvider {
    var languages: [Language] {
        return Array(languageToFilePath.keys)
    }

    func contentProvider(for language: Language) -> LocalizationProvider {
        let filePath = languageToFilePath[language]
        assert(filePath != nil)
        return AndroidLocalizationFileProvider(filePath: filePath!)
    }
}
