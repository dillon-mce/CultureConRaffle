//
//  PermutationChecker.swift
//  CultureConRaffle
//
//  Created by Dillon McElhinney on 2/9/21.
//

import Algorithms
import CryptoSwift
import Foundation

final class PermutationChecker {
    private let queue: DispatchQueue
    private let completion: (Result) -> Void

    init(number: Int,
         completion: @escaping (Result) -> Void) {
        self.queue = DispatchQueue(label: "Permutation-Checker-\(number)", qos: .userInitiated)
        self.completion = completion
    }

    func check(next combination: [String]?) {
        guard let combination = combination else { return }
        queue.async { [weak self] in
            combination.permutations().forEach { permutation in
                autoreleasepool {
                    let raffle = permutation.joined()
                    if self?.hashValue(raffle) == GlobalValues.hash {
                        self?.completion(.success(raffle))
                    }
                }
            }
            self?.completion(.failure(self))
        }
    }

    private func hashValue(_ raffle: String) -> String? {
        (GlobalValues.email + raffle).bytes.md5().toBase64()
    }

    enum Result {
        case success(String)
        case failure(PermutationChecker?)
    }
}
