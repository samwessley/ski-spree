//
//  SkiSpreeProducts.swift
//  slippy
//
//  Created by Sam Wessley on 2/23/20.
//  Copyright © 2020 Sam Wessley. All rights reserved.
//

import Foundation

public struct SkiSpreeProducts {
  
    public static let coins7500 = "com.eudeon.skispree.7500_coinpack"
    public static let coins45000 = "com.eudeon.skispree.45000_coinpack"
    public static let coins90000 = "com.eudeon.skispree.90000_coinpack"
    public static let coins180000 = "com.eudeon.skispree.180000_coinpack"
    public static let coins500000 = "com.eudeon.skispree.500000_coinpack"
    public static let coins1200000 = "com.eudeon.skispree.1200000_coinpack"
  
    private static let productIdentifiers: Set<ProductIdentifier> = [SkiSpreeProducts.coins7500, SkiSpreeProducts.coins45000, SkiSpreeProducts.coins90000, SkiSpreeProducts.coins180000, SkiSpreeProducts.coins500000, SkiSpreeProducts.coins1200000]

    public static let store = IAPHelper(productIds: SkiSpreeProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
