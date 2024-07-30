import SwiftUI

// MARK: - Input views and TableCell

/// A SwiftUI view that represents an input in the table view.
struct InputTableView: View {
    var item: String
    
    var body: some View {
        HStack {
            Text(item)
                .font(.custom("FiraSans-Regular", size: 14.0))
                .foregroundColor(Color("color_gray9"))
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
