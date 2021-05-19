//
//  DiffableTableViewController.swift
//  SwiftUiCodingThreeProject
//
//  Created by Kayla Runkel on 5/19/21.
//  Copyright © 2021 Kayla Runkel. All rights reserved.
//

import SwiftUI

class DiffableTableViewController: UITableViewController
{
    //setting up cells
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    lazy var source: updatesSource = .init(tableView: self.tableView) { (_, indexPath, updates) -> UITableViewCell? in
        let cell = updatesCell(style: .default, reuseIdentifier: nil)
        cell.viewModel.name = updates.name
        cell.viewModel.date = updates.date
        cell.viewModel.isFavorite = updates.isFavorite
        return cell
    }
    //swipe to delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //delete - delete button, delete from snapshot, apply to source
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            completion(true)
            
            //make the delete actually delete
            var snapshot = self.source.snapshot()
            //figure out the contact we need to delete
            guard let updates = self.source.itemIdentifier(for: indexPath)
                else { return }
            snapshot.deleteItems([updates])
            self.source.apply(snapshot)
        }
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { (_, _, completion) in
            completion(true)
            //need to reload cell inside a diffable data source
            var snapshot = self.source.snapshot()
            //easier to update class over struct b/c a class is a reference while struct is a value type
            guard let updates = self.source.itemIdentifier(for: indexPath)
                           else { return }
            updates.isFavorite.toggle()
            snapshot.reloadItems([updates])
            self.source.apply(snapshot)
        }
        
        return .init(actions: [deleteAction, favoriteAction])
    }
    

    //UITableViewDiffableDataSource
    
    private func setupSource()
    {
        
        var snapshot = source.snapshot()
        snapshot.appendSections([.practice, .competition])
        snapshot.appendItems([
            .init(name: "Bars", date: "January 3, 2021"),
            .init(name: "Floor", date: "March 4, 2019")
        ], toSection: .practice)
        snapshot.appendItems([
            .init(name: "Starstruck Invitational", date: "November 4, 2020"),
            .init(name: "Mock Meet", date: "May 28, 2018")
        ], toSection: .competition)
        
        source.apply(snapshot)
    }
    
    //creating sublabels for each section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = section == 0 ? "Practice Updates" : "Competition Updates"
        return label
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //tableView.backgroundColor = .purple
        navigationItem.title = "Updates"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = .init(title: "Add Update", style: .plain, target: self, action: #selector(handleAdd))
        
        setupSource()
    }
    @objc private func handleAdd()
    {
        let formView = UpdateFormView { (name, date, sectionType) in
            self.dismiss(animated: true) //dismisses view when add button on view is pressed
            //add an update
            if !name.isEmpty {
                var snapshot = self.source.snapshot()
                snapshot.appendItems([.init(name: name, date: date)], toSection: sectionType)
                self.source.apply(snapshot)
            }
        }
        let hostingController = UIHostingController(rootView: formView)
        present(hostingController, animated: true)
    }

}
