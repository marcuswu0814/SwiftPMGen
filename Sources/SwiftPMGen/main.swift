import Commander
import SwiftPMGenCore
import PathKit

Group {
    
    let makefileCommand = command(
        Option("prod-name", default: "", description: "Your swift package name"),
        Option("brew-name", default: "", description: "Your binary executable name")
    ) { prodName, brewName in
        guard !prodName.isEmpty, !brewName.isEmpty else {
            return
        }
        
        let generator = MakefileGenerator()
        let content = generator.content(withProdName: prodName,
                                        prodNameForHomebrew: brewName)
        let makefilePath = Path.current + Path("Makefile")
        try? makefilePath.write(content)
        
        print("Done!")
    }
    
    $0.addCommand("makefile", makefileCommand)
    
}.run()
