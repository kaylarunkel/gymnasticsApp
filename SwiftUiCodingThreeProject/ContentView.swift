//
//  ViewController.swift
//  CodingThreeApp2
//
//  Created by Kayla Runkel on 3/13/21.
//  Copyright © 2021 Kayla Runkel. All rights reserved.
//

import SwiftUI
import LBTATools

enum SectionType
{
    case practice, competition
}

class Updates: NSObject
{
    let name: String
    var isFavorite = false
    let date: String
    
    init(name: String, date: String)
    {
        self.name = name
        self.date = date
    }
}

//needed for swipe feature - need to subclass diffable data source for swipe function to work
class updatesSource: UITableViewDiffableDataSource<SectionType, Updates> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

