//
//  main.swift
//  CultureConRaffle
//
//  Created by Dillon McElhinney on 2/9/21.
//

import Algorithms
import ArgumentParser
import Foundation

enum GlobalValues {
    static var startTime = CFAbsoluteTimeGetCurrent()
    static var email = ""
    static var hash = ""
}

final class RaffleFinder: ParsableCommand {

    @Option(name: .shortAndLong, help: "The number of threads you want to use")
    var threads: Int = 1

    @Argument(help: "The email you want to use")
    var email: String

    @Argument(help: "The hashed string you want to check against")
    var hash: String

    public func run() throws {
        guard threads > 0 else { throw RaffleError.invalidThreadCount }

        logGlobalValues()

        var combinations = makeCombinations()
        let checkers = (1...threads).map { number in
            PermutationChecker(number: number) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let raffle):
                        print("The correct raffle code is: \(raffle)")
                        print("Found it in \(CFAbsoluteTimeGetCurrent() - GlobalValues.startTime) seconds!")
                        CoreFoundation.exit(0)
                    case .failure(let checker):
                        checker?.check(next: combinations.next())
                    }
                }
            }
        }
        checkers.forEach { $0.check(next: combinations.next()) }

        dispatchMain()
    }

    private func logGlobalValues() {
        GlobalValues.startTime = CFAbsoluteTimeGetCurrent()
        GlobalValues.email = email
        GlobalValues.hash = hash
    }

    private func makeCombinations() -> Combinations<[String]>.Iterator {
        "abcdefghijklmnopqrstuvwxyz1234567890"
            .map(String.init)
            .combinations(ofCount: 5)
            .makeIterator()
    }
}

enum RaffleError: Swift.Error {
    case invalidThreadCount
}

RaffleFinder.main()
