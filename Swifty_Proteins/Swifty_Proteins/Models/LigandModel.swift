//
//  LigandModel.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/19.
//  Copyright © 2018 WTC_. All rights reserved.
//

import Foundation
import UIKit

struct Atom
{
    let name: String!
    let atomic_mass: Double!
    let number: Int!
    let symbol: String!
    let summary: String!
}

struct Node
{
    let id: Int!
    var x_pos: Double!
    var y_pos: Double!
    var z_pos: Double!
    var node_color: UIColor!
    let atom: Atom!
}

struct Connection
{
    var node1: Node!
    var node2: Node!
}

struct LigandModel
{
    let name:  String!
    var nodes: [Node]?
    var connections: [Connection]?
}
