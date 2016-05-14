//
//  CLIArgumentsParserTests.swift
//  LocalizationFileConverter
//
//  Created by Sébastien Duperron on 14/05/2016.
//  Copyright © 2016 Sébastien Duperron
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import XCTest

class CLIArgumentsParserTests: XCTestCase {

    func test_parseAction_noArguments() throws {
        // GIVEN: a parser
        let parser = CLIArgumentsParser()
        // GIVEN: an expected error
        let expectThrownError = self.expectationWithDescription("Thrown error")

        // WHEN: we try to parse an empty array of arguments
        do {
            _ = try parser.parseAction(arguments: [])
        } catch CLIArgumentsParser.Error.NoAction {
            expectThrownError.fulfill()
        }

        // THEN: we got the expected error
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }

    func test_parseAction_help() {
        // GIVEN: a parser
        let parser = CLIArgumentsParser()

        // WHEN: we pass help as the action
        let action = try? parser.parseAction(arguments: ["help"])

        // THEN: we got the expected help action
        XCTAssertEqual(CLIAction.Help, action)
    }

}
