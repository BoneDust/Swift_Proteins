//
//  LigandModel.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/19.
//  Copyright © 2018 WTC_. All rights reserved.
//

import Foundation


struct Atom
{
    let name: String!
    let atomic_mass: Double!
    let category: String!
    let number: Int!
    let symbol: String!
}

struct LigandModel
{
    let name:  String!
    let atoms: [Atom]!
    let atomsArray: [String]!
    let connectionsArray: [String]!
}
