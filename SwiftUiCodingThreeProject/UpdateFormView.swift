//
//  UpdateFormView.swift
//  SwiftUiCodingThreeProject
//
//  Created by Kayla Runkel on 5/19/21.
//  Copyright © 2021 Kayla Runkel. All rights reserved.
//

import SwiftUI

struct UpdateFormView: View
{
    var didAddUpdate: (String, String, SectionType) -> () = { _,_,_  in }
    
    @State private var name = "" //everytime you type something in the state will change w/ the UI
    @State private var date = ""
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        //formatter.dateFormat = "YY/MM/dd"
        //formatter.string(from: selectedDate)
        return formatter
    }
    @State private var selectedDate = Date()
    @State private var sectionType = SectionType.practice
    @Environment(\.presentationMode) private var presentationMode
    
    
    
    var body: some View //for screen when you click Add Update
    {
        
        VStack(spacing: 20)
            {
                //$ = binding
                TextField("Name of Update", text: $name)
                //TextField("Date", text: $date)
                DatePicker("Select Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                //{
                //    Text("Select A Date")
                //}
                Text("Your selected date: \(selectedDate, formatter: dateFormatter)")
                Picker(selection: $sectionType, label: Text("doesn't show up"))
                {
                    //tags control what value gets controlled inside section type
                    Text("Practice").tag(SectionType.practice)
                    Text("Competition").tag(SectionType.competition)
                }
                .pickerStyle(SegmentedPickerStyle())
                Button(action: {
                    //run a function or closure somehow
                    //let date = "\(self.selectedDate, formatter: dateFormatter)"
                    //let stringDate = "\(self.selectedDate, formatter: self.dateFormatter)"
                    self.didAddUpdate(self.name, "\(self.selectedDate)", self.sectionType)
                }, label:
                    {
                    HStack
                        {
                            Spacer()
                            Text("Add").foregroundColor(.white)
                            Spacer()
                    }.padding().background(Color.blue)
                    .cornerRadius(5)
                })
                //cancel button - need to make function dismiss the view when the button is pressed
                Button(action: {
                    //run a function or closure somehow
                    self.didAddUpdate("", "", self.sectionType)
                    //self.presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    HStack
                        {
                            Spacer()
                            Text("Cancel").foregroundColor(.white)
                            Spacer()
                    }.padding().background(Color.red)
                    .cornerRadius(5)
                })
                Spacer()
        }
        .padding()
    }

}
