import Foundation
import SwiftUI


extension TestOverviewViewController {
    @objc private func setupDescriptorViews() {
        
        guard let descriptor = self.descriptor as? OONIDescriptor else {
            return
        }
        
        let contentView = OverviewContentView(
            descriptor: descriptor,
            nettests: descriptor.nettest.map { nettest in NettestStatus(nettest: nettest) }
        )
        
        let hostingController = UIHostingController(rootView: contentView)
        
        addChild(hostingController)
        
        if let hostingView = hostingController.view {
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(hostingView)
            NSLayoutConstraint.activate([
                hostingView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
                hostingView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20),
                hostingView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            ])
        }
        
    }
}

struct OverviewContentView: View {
    let descriptor:OONIDescriptor
    @State var runTestsAutomatically:Bool = false
    
    @State var installUpdatesAutomatically:Bool = false
    
    @State var nettests: [NettestStatus]
    
    var body: some View {
        
        let runTestsAutomaticallyBinding = Binding(
            get: { self.runTestsAutomatically },
            set: {
                runTestsAutomaticallyChanged($0)
            }
        )
        
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey(descriptor.longDescription))
                .padding(.top)
                .font(.custom("FiraSans-Regular", size: 14.0))
                .foregroundColor(Color("color_gray9"))
            Text("Test Settings")
                .bold()
                .padding(.top)
                .padding(.bottom)
            Toggle("Install updates automatically", isOn: $installUpdatesAutomatically)
            Toggle("Run tests automatically", isOn: runTestsAutomaticallyBinding).toggleStyle(iOSCheckboxToggleStyle())
            UITableViewWrapper(
                nettests: $nettests,
                didSelectRow: { indexPath in
                    let allEnabled = nettests.allSatisfy({ nettest in
                        nettest.isSelected
                    })
                    runTestsAutomatically = allEnabled
                })
            .padding(.bottom)
            .frame(height: 1000)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    func runTestsAutomaticallyChanged(_ newState: Bool) {
        nettests.forEach({ nettest in
            // TODO: save to database
            nettest.isSelected = newState
        })
        self.runTestsAutomatically = newState
    }
}

// MARK: - UITableViewWrapper

/// A SwiftUI view that wraps a UITableView.
struct UITableViewWrapper: UIViewRepresentable {
    @Binding var nettests: [NettestStatus]
    var didSelectRow: ((IndexPath) -> Void) // Event listener closure
    
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(NettestTableViewCell.self, forCellReuseIdentifier: "nettests_cell")
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "inputs_cell")
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// A class that conforms to the UITableViewDataSource and UITableViewDelegate protocols.
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var parent: UITableViewWrapper
        
        init(_ parent: UITableViewWrapper) {
            self.parent = parent
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            parent.nettests.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            let section = parent.nettests[section]
            if section.isExpanded {
                
                if let inputs = section.nettest.inputs, !inputs.isEmpty {  // Check if the section(`nettest`) has inputs
                    return inputs.count + 1 // Return the number of inputs plus 1 (for the section header)
                } else {
                    return 1 // Return 1 if there are no inputs (only the section header)
                }
            } else {
                return 1 // Return 1 if the section is not expanded (only the section header)
            }
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nettests_cell") as! NettestTableViewCell
                
                cell.configure(
                    with: parent.nettests[indexPath.section],
                    onToggleChange: { [weak self] newValue in
                        //TODO: Save preference change to database
                        // Update the isSelected property of the NettestStatus object for the current section to the new value of the toggle.
                        self?.parent.nettests[indexPath.section].isSelected = newValue
                        // Invoke the didSelectRow closure with the selected indexPath
                        self?.parent.didSelectRow(indexPath)
                        tableView.reloadData()
                    }
                )
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "inputs_cell") as! InputTableViewCell
                
                if let inputs = parent.nettests[indexPath.section].nettest.inputs, !inputs.isEmpty {
                    
                    cell.configure(with: inputs[indexPath.row  - 1])
                    return cell
                } else {
                    return cell
                }
                
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if indexPath.row == 0{
                parent.nettests[indexPath.section].isExpanded = !parent.nettests[indexPath.section].isExpanded
            }
            
            UIView.transition(
                with: tableView,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: {
                    tableView.reloadData()
                }
            )
            
        }
    }
}
