// MARK: - NettestStatus

/// A struct that represents the status of a Nettest.
class NettestStatus : ObservableObject {
    var nettest: Nettest
    @Published var isSelected: Bool = false
    @Published var isExpanded: Bool = false
    
    init(nettest: Nettest) {
        self.nettest = nettest
    }
}
