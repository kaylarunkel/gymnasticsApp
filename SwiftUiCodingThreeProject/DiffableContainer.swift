//
//  DiffableContainer.swift
//  SwiftUiCodingThreeProject
//
//  Created by Kayla Runkel on 5/19/21.
//  Copyright © 2021 Kayla Runkel. All rights reserved.
//

import SwiftUI

struct DiffableContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController
    {
        UINavigationController(rootViewController: DiffableTableViewController(style: .insetGrouped)) // adds navigation bar at top
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: Context)
    {
        
    }
    typealias UIViewControllerType = UIViewController
}

//make it so clicking on a cell will take us to a new view controller
