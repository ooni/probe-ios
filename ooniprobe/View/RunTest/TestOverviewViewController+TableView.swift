import Foundation
import SwiftUI

struct OverviewContentView: View {
    let descriptor:OONIDescriptor
    @State var runTestsAutomatically:Bool = false {
            didSet {
                updateNettests(runTestsAutomatically)
            }
        }
    @State var installUpdatesAutomatically:Bool = false
    
    var body: some View {
        HStack{
            VStack {
                Text(descriptor.longDescription)
                    .font(.callout)
                    .padding()
                Text("Test Settings")
                Toggle("Install updates automatically", isOn: $installUpdatesAutomatically)
                Toggle("Run tests automatically", isOn: $runTestsAutomatically).toggleStyle(iOSCheckboxToggleStyle())
                UITableViewWrapper(nettests: descriptor.nettest)
                    .frame(height: 1000)
            }
        }
    }

    func updateNettests(_ newValue: Bool) {
        // ... update nettests array ...
    }
}

extension TestOverviewViewController {
    open override func viewDidAppear(_ animated: Bool) {
        
        let contentView = OverviewContentView(descriptor: self.descriptor as! OONIDescriptor)
        
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

// MARK: - NettestStatus

/// A struct that represents the status of a Nettest.
struct NettestStatus {
    var nettest: Nettest
    var isSelected: Bool = false
    var isExpanded: Bool = false
}

// MARK: - MarkdownLabel

/// A SwiftUI view that displays a Markdown label.
struct MarkdownLabel: UIViewRepresentable {
    var rect: CGRect
    
    func makeUIView(context: Context) -> RHMarkdownLabel {
        return RHMarkdownLabel(frame: rect)
    }
    
    func updateUIView(_ uiView: RHMarkdownLabel, context: Context) {
        uiView.markdown = NSLocalizedString("Dashboard.InstantMessaging.Overview.Paragraph", comment: "")
    }
}

// MARK: - UITableViewWrapper

/// A SwiftUI view that wraps a UITableView.
struct UITableViewWrapper: UIViewRepresentable {
    var nettests: [NettestStatus]
    
    /// Initializes a new instance of the UITableViewWrapper struct.
    /// - Parameter nettests: An array of Nettest objects.
    init(nettests: [Nettest]) {
        self.nettests = nettests.map { nettest in NettestStatus(nettest: nettest) }
    }
    
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
            
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { tableView.reloadData() })
            
            print("\(indexPath.section)-\(indexPath.row)")
        }
    }
}


/// A SwiftUI toggle style that uses a checkbox.
struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                configuration.label
                Spacer()
                Image(systemName: configuration.isOn ? "checkmark.square" : "square").padding()
            }
        })
    }
}

// MARK: - Nettests views and TableCell

/// A SwiftUI view that represents a section in the table view.
struct SectionTableCell: View {
    var item: NettestStatus
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(LocalizationUtility.getNameForTest(item.nettest.name)).padding()
            if let inputs = item.nettest.inputs, !inputs.isEmpty {
                Image(systemName: item.isExpanded ? "chevron.up" : "chevron.down")
            } else {
                Spacer()
            }
            Spacer()
            Toggle(isOn: $isOn) {}.toggleStyle(iOSCheckboxToggleStyle())
        }
    }
}

/// A UITableViewCell subclass that displays a section in the table view.
class NettestTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<SectionTableCell>?
    
    /// Configures the cell with the specified data.
    /// - Parameters:
    ///   - data: The NettestStatus object.
    ///   - onToggleChange: A closure that is called when the toggle is changed.
    func configure(with data: NettestStatus, onToggleChange: @escaping (Bool) -> Void) {
        // Create a binding to pass the data to the SwiftUI view
        let binding = Binding<Bool>(
            get: { data.isSelected },
            set: { newValue in
                onToggleChange(newValue)
            }
        )
        
        let toggleCellView = SectionTableCell(item:data, isOn: binding)
        
        if let hostingController = hostingController {
            hostingController.rootView = toggleCellView
        } else {
            hostingController = UIHostingController(rootView: toggleCellView)
            if let hostingView = hostingController?.view {
                hostingView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(hostingView)
                NSLayoutConstraint.activate([
                    hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
            }
        }
    }
}

// MARK: - Input views and TableCell

/// A SwiftUI view that represents an input in the table view.
struct InputTableView: View {
    var item: String
    
    var body: some View {
        HStack {
            Text(item).padding()
            Spacer()
        }
    }
}

/// A UITableViewCell subclass that displays an input in the table view.
class InputTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<InputTableView>?
    
    /// Configures the cell with the specified data.
    /// - Parameter data: The input string.
    func configure(with data: String) {
        
        let toggleCellView = InputTableView(item:data)
        
        if let hostingController = hostingController {
            hostingController.rootView = toggleCellView
        } else {
            hostingController = UIHostingController(rootView: toggleCellView)
            if let hostingView = hostingController?.view {
                hostingView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(hostingView)
                NSLayoutConstraint.activate([
                    hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
            }
        }
    }
}
