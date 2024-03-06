import Foundation
import SwiftUI

struct CircularProgressView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                    .stroke(
                            Color("color_base"),
                            lineWidth: 5
                    )
            Circle()
                    // 2
                    .trim(from: 0, to: progress)
                    .stroke(
                            Color("color_base"),
                            style: StrokeStyle(
                                    lineWidth: 5,
                                    lineCap: .round
                            )
                    )
                    .rotationEffect(.degrees(-90))
        }
    }
}

struct LoadingView: View {
    let controller: UIViewController
    @State private var progress = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ZStack {
                Color("color_gray7_1")
                        .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        CircularProgressView(progress: progress)
                                .frame(width: 30, height: 30)
                                .onReceive(timer) { _ in
                                    withAnimation {
                                        progress += 0.01
                                        if progress >= 1 {
                                            progress = 0
                                        }
                                    }
                                }
                        Text("Link Loading")
                                .foregroundColor(Color("color_white"))
                    }
                    Spacer()
                            .frame(height: 30)
                    Button(action: {
                        controller.dismiss(animated: true)
                    }) {
                        Text("Cancel")
                                .foregroundColor(Color("color_white"))
                    }
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color("color_white"), lineWidth: 2))
                }
            }
        }
    }
}

class LaunchScreenController: UIViewController {

    public var runId: CLong = 0

    private var descriptorResponse: DescriptorResponse?

    @objc func setRunId(url: URL) {

        if (url.host == "run.test.ooni.org") {
            url.pathComponents.last.map {
                runId = CLong($0) ?? 0
            }
        } else if (url.host == "runv2") {
            url.pathComponents.last.map {
                runId = CLong($0) ?? 0
            }
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let controller = UIHostingController(rootView: LoadingView(controller: self))
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        fetchDescriptor()
    }

    func fetchDescriptor() {
        DispatchQueue.global().async {
            TestDescriptorManager.fetchDescriptor(
                    fromRunId: self.runId, onSuccess: {
                (response: DescriptorResponse) in
                DispatchQueue.main.async {
                    self.descriptorResponse = response
                    self.performSegue(withIdentifier: "add_descriptor", sender: self)
                }
            }) { (error: Error) in
                print(error)
                self.dismiss(animated: true)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add_descriptor" {
            if let destinationVC = segue.destination as? AddDescriptorController {
                destinationVC.descriptorResponse = descriptorResponse
            }
        }
    }
}
