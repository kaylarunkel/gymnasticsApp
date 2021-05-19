//
//  UpdatesRowView.swift
//  SwiftUiCodingThreeProject
//
//  Created by Kayla Runkel on 5/19/21.
//  Copyright © 2021 Kayla Runkel. All rights reserved.
//

import SwiftUI

struct UpdatesRowView: View
{
    @ObservedObject var viewModel: updatesViewModel
    
    var name = "name"
    var date = "date"
    
    var body: some View
    {
        HStack (spacing: 16)
            {
                //Image(systemName: "person.fill")
                    //.font(.system(size:34))
                VStack(alignment: .leading)
                {
                    Text(viewModel.name)
                        .font(.system(size: 20))
                        .bold()
                    Text(viewModel.date)
                        .font(.system(size: 15))
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                    .font(.system(size: 20))
                //Spacer()
                //navigation link used so when the user clicks the paperplane, they will be taken to the SecondView
                NavigationLink(destination: AddInfoToUpdateView(update: viewModel.name)) {
                   // Text("Click Here")
                    Image(systemName: "paperplane.fill")
                }
        }.padding(20)
    }
}
