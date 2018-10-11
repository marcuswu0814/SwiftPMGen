import XCTest
import SwiftPMGenCore

final class MakefileGeneratorTests: XCTestCase {
    
    func test__givenProdName__returnMakefileContent() {
        let sut = MakefileGenerator()
        
        let result = sut.content(withProdName: "TestProd",
                                 prodNameForHomebrew: "test-prod")
        
        XCTAssertEqual(result, exceptResult)
    }
    
    private var exceptResult: String {
        return """
        PREFIX?=/usr/local

        PROD_NAME=TestProd
        PROD_NAME_HOMEBREW=test-prod

        build:
        \tswift build --disable-sandbox -c release -Xswiftc -static-stdlib

        build-for-linux:
        \tswift build --disable-sandbox -c release

        run:
        \t.build/release/$(PROD_NAME)

        test: xcode
        \tset -o pipefail && xcodebuild -scheme "${PROD_NAME}-Package" -enableCodeCoverage YES clean build test | xcpretty

        lint:
        \tswiftlint

        update:
        \tswift package update

        clean:
        \tswift package clean

        xcode:
        \tswift package generate-xcodeproj

        install: build
        \tmkdir -p "$(PREFIX)/bin"
        \tcp -f ".build/release/$(PROD_NAME)" "$(PREFIX)/bin/$(PROD_NAME_HOMEBREW)"
        """
    }
    
}

