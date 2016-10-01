//
//  TableViewController.swift
//  GiphySwift-Example
//
//  Created by Matias Seijas on 9/29/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import UIKit

enum Section: Int {
    case gifs, stickers
    
    var title: String {
        switch self {
        case .gifs: return "Gifs"
        case .stickers: return "Stickers"
        }
    }
    
    var rows: [Row] {
        switch self {
        case .gifs: return [Row.trending, Row.search, Row.translate, Row.byID, Row.random]
        case .stickers: return [Row.trending, Row.search, Row.translate, Row.random]
        }
        
    }
    
    static var count: Int { return 2 }
}

enum Row: Int {
    case trending, search, translate, byID, random
    
    var title: String {
        switch self {
        case .trending: return "Trending"
        case .search: return "Search"
        case .translate: return "Translate"
        case .byID: return "By ID"
        case .random: return "Random"
        }
    }
}

class TableViewController: UITableViewController {
    
    var config: (section: Section, row: Row)?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError("Could not retrieve Section") }
        return section.rows.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Could not retrieve Section") }
        let row = section.rows[indexPath.row]
        
        cell.textLabel?.text = row.title
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { fatalError("Could not retrieve Section") }
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Could not retrieve Section") }
        let row = section.rows[indexPath.row]
        config = (section: section, row: row)
        performSegue(withIdentifier: "showImages", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let collectionViewController = segue.destination as? CollectionViewController else { return }
        collectionViewController.config = self.config
    }
}
