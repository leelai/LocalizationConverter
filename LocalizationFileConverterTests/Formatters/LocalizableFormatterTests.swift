//
//  LocalizableFormatterTests.swift
//  LocalizationFileConverter
//
//  Created by Sébastien Duperron on 14/05/2016.
//  Copyright © 2016 Sébastien Duperron
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest

class LocalizableFormatterTests: XCTestCase {

    func test_format_noLocalizationKeys() {
        let localizableFormatter = LocalizableFormatter()
        let localization = LocalizationMap(type: .android)

        let resultLocalizableString = localizableFormatter.format(localization)

        XCTAssertEqual("", resultLocalizableString)
    }

    func test_format_oneStringLocalizedValue() {
        let localizableFormatter = LocalizableFormatter()
        let localization = LocalizationMap(type: .android, localizationsDictionary: ["key": LocalizationItem.string(value: "localized_value")])

        let resultLocalizableString = localizableFormatter.format(localization)

        XCTAssertEqual("key = \"localized_value\";", resultLocalizableString)
    }

    func test_format_multipleStringsLocalizedValue() {
        let localizableFormatter = LocalizableFormatter()
        let localization = LocalizationMap(type: .android, localizationsDictionary: [
            "key1": LocalizationItem.string(value: "localized_value1"),
            "key0": LocalizationItem.string(value: "localized_value0"),
            "key2": LocalizationItem.string(value: "localized_value2"),
        ])

        let resultLocalizableString = localizableFormatter.format(localization)

        XCTAssertEqual("key0 = \"localized_value0\";\nkey1 = \"localized_value1\";\nkey2 = \"localized_value2\";", resultLocalizableString)
    }

    func test_format_ignorePluralsLocalizedValues() {
        let localizableFormatter = LocalizableFormatter()
        let localization = LocalizationMap(type: .android, localizationsDictionary: [
            "key2": LocalizationItem.string(value: "localized_value2"),
            "key0": LocalizationItem.string(value: "localized_value0"),
            "pluralKey": LocalizationItem.plurals(values: [.zero: "zero_value", .other: "other_value"]),
            "key1": LocalizationItem.string(value: "localized_value1"),
            ])

        let resultLocalizableString = localizableFormatter.format(localization)

        XCTAssertEqual("key0 = \"localized_value0\";\nkey1 = \"localized_value1\";\nkey2 = \"localized_value2\";", resultLocalizableString)
    }

    func test_format_convertStringParameters() {
        let localizableFormatter = LocalizableFormatter()
        let localization = LocalizationMap(type: .android, localizationsDictionary: [
            "stringParams": LocalizationItem.string(value: "Hello %s %s!"),
            ])

        let resultLocalizableString = localizableFormatter.format(localization)

        XCTAssertEqual("stringParams = \"Hello %@ %@!\";", resultLocalizableString)
    }

    func test_format_convertPositionalStringParameters() {
        let localizableFormatter = LocalizableFormatter()
        let localization = LocalizationMap(type: .android, localizationsDictionary: [
            "positionalParams": LocalizationItem.string(value: "Hello %1$s %2$s!"),
            ])

        let resultLocalizableString = localizableFormatter.format(localization)

        XCTAssertEqual("positionalParams = \"Hello %1$@ %2$@!\";", resultLocalizableString)
    }
}
