//
//  UpdatesViewModel.swift
//  SwiftUiCodingThreeProject
//
//  Created by Kayla Runkel on 5/19/21.
//  Copyright © 2021 Kayla Runkel. All rights reserved.
//

import SwiftUI

class updatesViewModel: ObservableObject //cell wil change or update when viewModel changes
{
    @Published var name = ""
    @Published var isFavorite = false
    @Published var date = ""
}

class updatesCell: UITableViewCell
{
   
    let viewModel = updatesViewModel()
    
    lazy var row = UpdatesRowView(viewModel: viewModel)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //setup my SwiftUI view somehow...
        let hostingController = UIHostingController(rootView: row)
        addSubview(hostingController.view)
        //need LBTATools
        hostingController.view.fillSuperview() //from LBTATools
        
        viewModel.name = "SOMETHING COMPLETELY NEW" //control name through viewModel
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
