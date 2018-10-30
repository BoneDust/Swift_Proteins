//
//  LigandModel.swift
//  Swifty_Proteins
//
//  Created by Goodwill TSHEKELA on 2018/10/19.
//  Copyright © 2018 WTC_. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

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
    var x_pos: Float!
    var y_pos: Float!
    var z_pos: Float!
    var node_color: UIColor!
    let atom: Atom!
    var plotted: Bool!
    var plottedVector: SCNVector3!
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
