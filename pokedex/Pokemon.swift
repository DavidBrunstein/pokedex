//
//  Pokemon.swift
//  pokedex
//
//  Created by David Brunstein on 2017-04-15.
//  Copyright © 2017 David Brunstein. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name:String!
    private var _pokedexId: Int!
    
    var name:String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    
    init (name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}
