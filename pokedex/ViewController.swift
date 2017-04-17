//
//  ViewController.swift
//  pokedex
//
//  Created by David Brunstein on 2017-04-15.
//  Copyright © 2017 David Brunstein. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
          
    var pokemonList = [Pokemon]()
    var filteredPokemonList = [Pokemon]()
    var inSearchMode: Bool = false
    
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
    
        initAudio()
        parsePokemonCSV()
    }
    
    
    func initAudio() {
    
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            // print(rows)
            for row in rows {
                let pokemonId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let pokemon = Pokemon(name: name, pokedexId: pokemonId)
                pokemonList.append(pokemon)
            }
            
        } catch let err as NSError {
            print(err.localizedDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokemonCell {
            
            let pokemon: Pokemon
            if inSearchMode {
                pokemon = filteredPokemonList[indexPath.row]
            } else {
               pokemon = pokemonList[indexPath.row]
            }
            
            cell.configureCell(pokemon: pokemon)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataCount: Int
        
        if inSearchMode {
            dataCount = filteredPokemonList.count
        } else {
            dataCount = pokemonList.count
        }
        return dataCount
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton!) {
        
        if musicPlayer.isPlaying {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            
            let lowerFilteredText = searchBar.text!.lowercased()
            filteredPokemonList = pokemonList.filter({$0.name.range(of: lowerFilteredText) != nil})
            collection.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}

