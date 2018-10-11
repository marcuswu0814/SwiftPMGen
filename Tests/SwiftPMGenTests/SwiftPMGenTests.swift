import XCTest
import PathKit
import SwiftCLIToolbox

final class SwiftPMGenTests: XCTestCase {
    
    static var allTests = [
        ("test__runSwitfPMGemCommand__createMakefileInCurrentFolder", test__runSwitfPMGemCommand__createMakefileInCurrentFolder),
    ]
    
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
    
    private lazy var tmpPath = Path("/tmp/SwiftPMGenTests")
    
    private lazy var makefilePath = tmpPath + Path("Makefile")
    
    override func setUp() {
        super.setUp()
        
        try? tmpPath.mkdir()
    }
    
    func test__runSwitfPMGemCommand__createMakefileInCurrentFolder() {
        guard #available(macOS 10.13, *) else { return }
        
        let binaryPath = productsDirectory.appendingPathComponent("SwiftPMGen")
        
        let process = Process()
        process.currentDirectoryPath = tmpPath.string
        process.executableURL = binaryPath
        process.arguments = ["makefile",
                             "--prod-name", "TestProd",
                             "--brew-name", "test-prod"]
        
        let pipe = Pipe()
        process.standardOutput = pipe

        try! process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        XCTAssertEqual(output, "Done!\n")
        XCTAssertTrue(makefilePath.exists)
        
        let result: String? = try? makefilePath.read()
        XCTAssertEqual(result, exceptResult)
    }
    
    private var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }
    
    override func tearDown() {
        try? tmpPath.delete()
        try? makefilePath.delete()
        
        super.tearDown()
    }
    
}
