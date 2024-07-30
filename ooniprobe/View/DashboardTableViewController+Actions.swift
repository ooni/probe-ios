import Foundation
import SwiftUI

extension DashboardTableViewController {
    @objc @IBAction private func runAll() {
        
        if let descriptorList = self.items as NSArray as? [OONIDescriptor]{
            
            let hostingController = UIHostingController(
                rootView: ModalView(
                    descriptors: descriptorList.map { descriptor in OONIDescriptorStatus(descriptor: descriptor) },
                    runTests: { descriptors in
                        if(TestUtility.checkConnectivity(self) && TestUtility.checkTestRunning(self)){
                            RunningTest.current().setAndRun(
                                NSMutableArray(array: descriptors.filter{ descriptor in
                                    descriptor.isSelected
                                }.map{ descriptor in
                                    descriptor.getTestSuites()
                                }),
                                inView: self
                            )
                        }
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                )
            )
            
            hostingController.modalPresentationStyle = .formSheet
            present(hostingController, animated: true, completion: nil)
        }
        
    }
}

// MARK: - OONIDescriptorStatus

/// A struct that represents the status of an OONIDescriptor.
class OONIDescriptorStatus : ObservableObject {
    var descriptor: OONIDescriptor
    @Published var nettests: [NettestStatus]
    @Published var isSelected: Bool = false
    @Published var isExpanded: Bool = true
    
    init(descriptor: OONIDescriptor) {
        self.descriptor = descriptor
        self.nettests = descriptor.nettest.map { nettest in NettestStatus(nettest: nettest) }
    }
    
    
    @objc public func getTestSuites() -> Any {
        descriptor.nettest = nettests.filter{ nettest in
            nettest.isSelected
        }.map{  nettest in
            nettest.nettest
        }
        return DynamicTestSuite(descriptor: descriptor)
    }
}


struct ModalView: View {
    
    @State var descriptors: [OONIDescriptorStatus]
    var runTests: (([OONIDescriptorStatus]) -> Void) // Event listener closure
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            Text("Select the tests to run")
            Button(action: {
                toggleStatusForAll(true)
            }, label: {
                Text("Select all tests")
                
                    .padding(.all,10)
                    .foregroundColor(Color("color_blue5"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color("color_blue5"), lineWidth: 2)
                    )
            })
            .cornerRadius(32)
            Button(action: {
                toggleStatusForAll(false)
            }, label: {
                Text("Deselect all tests")
                
                    .padding(.all,10)
                    .foregroundColor(Color("color_blue5"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color("color_blue5"), lineWidth: 2)
                    )
            })
            .cornerRadius(32)
            
            RunTestsUITableViewWrapper(
                descriptors: $descriptors,
                didSelectRow: { indexPath in
                    
                })
            HStack {
                Spacer()

                Button(action: {
                    runTests(descriptors)
                }, label: {
                    Text("Run test")
                    
                        .padding(.all,10)
                        .foregroundColor(Color("color_white"))
                        .background(Color("color_blue5"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color("color_blue5"), lineWidth: 2)
                        )
                })
                .cornerRadius(32)
                Spacer()

            }
            
        }
        .padding()
    }
    
    func toggleStatusForAll(_ newState: Bool) {
        descriptors.forEach({ descriptor in
            descriptor.isSelected = newState
            descriptor.nettests.forEach({ nettest in
                nettest.isSelected = newState
            })
        })
        
        descriptors = descriptors
    }
}


// MARK: - RunTestsUITableViewWrapper

/// A SwiftUI view that wraps a UITableView.
struct RunTestsUITableViewWrapper: UIViewRepresentable {
    @Binding var descriptors: [OONIDescriptorStatus]
    var didSelectRow: ((IndexPath) -> Void) // Event listener closure
    
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(DescriptorTableViewCell.self, forCellReuseIdentifier: "descriptor_cell")
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
        var parent: RunTestsUITableViewWrapper
        
        init(_ parent: RunTestsUITableViewWrapper) {
            self.parent = parent
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            parent.descriptors.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let section = parent.descriptors[section]
            if section.isExpanded {
                return section.nettests.count + 1
            } else {
                return 1 // Return 1 if the section is not expanded (only the section header)
            }
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptor_cell") as! DescriptorTableViewCell
                
                cell.configure(
                    with: parent.descriptors[indexPath.section],
                    onToggleChange: { [weak self] newValue in
                        self?.parent.descriptors[indexPath.section].isSelected = newValue
                        self?.parent.didSelectRow(indexPath)
                        tableView.reloadData()
                    }
                )
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nettests_cell") as! NettestTableViewCell
                
                let inputs = parent.descriptors[indexPath.section].nettests[indexPath.row  - 1]
                cell.configure(
                    with: inputs,
                    isChild: true,
                    onToggleChange: { [weak self] newValue in
                        self?.parent.descriptors[indexPath.section].nettests[indexPath.row  - 1].isSelected = newValue

                        self?.parent.didSelectRow(indexPath)
                        tableView.reloadData()
                    }
                )
                
                return cell
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if indexPath.row == 0{
                parent.descriptors[indexPath.section].isExpanded = !parent.descriptors[indexPath.section].isExpanded
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



// MARK: - Descriptor views and TableCell

/// A SwiftUI view that represents a section in the table view.
struct DescriptorTableCell: View {
    var item: OONIDescriptorStatus
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(LocalizationUtility.getNameForTest(item.descriptor.title))
                .font(.custom("FiraSans-Regular", size: 14.0))
                .foregroundColor(Color("color_gray9"))
                .lineLimit(1)
                .layoutPriority(1)
            Image(systemName: item.isExpanded ? "chevron.up" : "chevron.down")
            Toggle(isOn: $isSelected) {}.toggleStyle(iOSCheckboxToggleStyle())
        }
    }
}

/// A UITableViewCell subclass that displays a section in the table view.
class DescriptorTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<DescriptorTableCell>?
    
    /// Configures the cell with the specified data.
    /// - Parameters:
    ///   - data: The NettestStatus object.
    ///   - onToggleChange: A closure that is called when the toggle is changed.
    func configure(with data: OONIDescriptorStatus, onToggleChange: @escaping (Bool) -> Void) {
        // Create a binding to pass the data to the SwiftUI view
        let binding = Binding<Bool>(
            get: { data.isSelected },
            set: { newValue in
                data.isSelected = newValue
                onToggleChange(newValue)
            }
        )
        
        let toggleCellView = DescriptorTableCell(item: data, isSelected: binding)
        
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
