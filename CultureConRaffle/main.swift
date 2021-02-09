//
//  main.swift
//  CultureConRaffle
//
//  Created by Dillon McElhinney on 2/9/21.
//

import Algorithms
import CryptoSwift
import Foundation

let hash = "zdVljhHnF+CnhphNzQWHRQ=="
let email = "dillon.mcelhinney@ibotta.com"

let alphabet = "abcdefghijklmnopqrstuvwxyz1234567890"
var combinations = 0
let startTime = CFAbsoluteTimeGetCurrent()
alphabet.map(String.init).combinations(ofCount: 5).forEach { combo in
    combinations += 1
    combo.permutations().forEach { permutation in
        autoreleasepool {
            let raffle = permutation.joined()
            if let test = (email + raffle).bytes.md5().toBase64(),
               test == hash {
                print("Found it!")
                print("The correct raffle is \(raffle)")
            }
        }
    }
    if combinations % 10000 == 0 {
        print("Checked \(combinations) combinations - \(CFAbsoluteTimeGetCurrent() - startTime) sec")
    }
}
