import SwiftUI

/// A SwiftUI toggle style that uses a checkbox.
struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                configuration.label
                Spacer()
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .padding()
            }
        }).foregroundColor(.black)
    }
}

// MARK: - Nettests views and TableCell

/// A SwiftUI view that represents a section in the table view.
struct NettestTableCell: View {
    var item: NettestStatus
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(LocalizationUtility.getNameForTest(item.nettest.name))
                .font(.callout)
                .lineLimit(1)
                .layoutPriority(1)
            if let inputs = item.nettest.inputs, !inputs.isEmpty {
                Image(systemName: item.isExpanded ? "chevron.up" : "chevron.down")
            } else {
                Spacer()
            }
            Toggle(isOn: $isSelected) {}.toggleStyle(iOSCheckboxToggleStyle())
        }
    }
}

/// A UITableViewCell subclass that displays a section in the table view.
class NettestTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<NettestTableCell>?
    
    /// Configures the cell with the specified data.
    /// - Parameters:
    ///   - data: The NettestStatus object.
    ///   - onToggleChange: A closure that is called when the toggle is changed.
    func configure(with data: NettestStatus, onToggleChange: @escaping (Bool) -> Void) {
        // Create a binding to pass the data to the SwiftUI view
        let binding = Binding<Bool>(
            get: { data.isSelected },
            set: { newValue in
                data.isSelected = newValue
                onToggleChange(newValue)
            }
        )
        
        let toggleCellView = NettestTableCell(item: data, isSelected: binding)
        
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
