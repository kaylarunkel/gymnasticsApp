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

class updatesViewModel: ObservableObject //cell wil change or update when viewModel changes
{
    @Published var name = ""
    @Published var isFavorite = false
    @Published var date = ""
}

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
                NavigationLink(destination: SecondView(update: viewModel.name)) {
                   // Text("Click Here")
                    Image(systemName: "paperplane.fill")
                }
        }.padding(20)
    }
}
struct SecondView: View {
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

//needed for swipe feature - need to subclass diffable data source for swipe function to work
class updatesSource: UITableViewDiffableDataSource<SectionType, Updates> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}

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
        let formView = updateFormView { (name, date, sectionType) in
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
    //dismiss screen when cancel button is pressed
   /* @objc private func cancelForm() //not part of video - added myself
    {
        let formView = updateFormView { (name, date, sectionType) in self.dismiss(animated: true)
        
        }
        let hostingController = UIHostingController(rootView: formView)
        present(hostingController, animated: true)
    }*/

struct updateFormView: View
{
    var didAddUpdate: (String, String, SectionType) -> () = { _,_,_  in }
    
    @State private var name = "" //everytime you type something in the state will change w/ the UI
    @State private var date = ""
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
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
//shows a preview of the form
struct UpdateFormView: PreviewProvider
{
    static var previews: some View
    {
        updateFormView()
    }
}

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


struct ContentView_Previews: PreviewProvider
{
    static var previews: some View
    {
        DiffableContainer()
    }
}

/*struct ContentView: View
{
    var body: some View
    {
        Text("65432532")
    }
}*/

