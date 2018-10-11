public class MakefileGenerator {
    
    public init() {}
    
    public func content(withProdName prodName: String, prodNameForHomebrew: String) -> String {
        return """
        PREFIX?=/usr/local
        
        PROD_NAME=\(prodName)
        PROD_NAME_HOMEBREW=\(prodNameForHomebrew)
        
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
