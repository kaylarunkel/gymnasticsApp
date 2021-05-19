//
//  AddInfoToUpdateView.swift
//  SwiftUiCodingThreeProject
//
//  Created by Kayla Runkel on 5/19/21.
//  Copyright © 2021 Kayla Runkel. All rights reserved.
//

import SwiftUI

struct AddInfoToUpdateView: View {
    let update: String
    
    @State private var what = ""
    @State private var why = ""
    @State private var event = ""
    @State private var competition2 = false
    @State private var practice = false
    @State private var vaultScore = 8.0
    @State private var barScore = 8.0
    @State private var beamScore = 8.0
    @State private var floorScore = 8.0
    
    var body: some View {
        //Text("Hello, Second View!")
        /*Text(update)
            .font(.largeTitle)
            .fontWeight(.medium)
            .foregroundColor(Color.blue)*/
        
        NavigationView {
            Form {
                Toggle(isOn: $competition2, label: {Text("Competition?")})
                Toggle(isOn: $practice, label: {Text("Practice?")})
                Section(header: Text("Practice Details")){
                    
                    
                    
                    if self.isPractice(){
                        TextField("What did you do?", text: $what)
                            TextField("What cues did you use? What did you fix", text: $why)
                        
                            Picker(selection: $event, label: Text("Event")) {
                                ForEach(Event.allEvents, id: \.self) { event in Text(event).tag(event)
                            }
                            }
                            Button(action: {
                                print("Updated")
                            }, label: {
                                Text("Update")
                            })
                        }
                    }
                    
                Section(header: Text("Competion Details")){
                    if self.isCompetition() {
                        Stepper(value: $vaultScore, in: 0...10, step: 0.05, label: {
                            Text("Vault Score: \(vaultScore, specifier: "%.2f")")
                        })
                        Stepper(value: $barScore, in: 0...10, step: 0.05, label: {
                            Text("Bar Score: \(barScore, specifier: "%.2f")")
                        })
                        Stepper(value: $beamScore, in: 0...10, step: 0.05, label: {
                            Text("Beam Score: \(beamScore, specifier: "%.2f")")
                        })
                        Stepper(value: $floorScore, in: 0...10, step: 0.05, label: {
                            Text("Floor Score: \(floorScore, specifier: "%.2f")")
                        })
                    }
                }
            }.navigationBarTitle(update)
        }
    }
    private func isCompetition() -> Bool {
        if !competition2 {
            return false
        }
        return true
    }
    private func isPractice() -> Bool {
        if !practice {
            return false
        }
        return true
    }
}

struct Event {
    static let allEvents = [
        "Vault",
        "Bars",
        "Beam",
        "Floor",
        "All Around"
    ]
}
