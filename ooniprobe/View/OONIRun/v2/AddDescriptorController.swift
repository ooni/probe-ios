import Foundation
import SwiftUI

struct AddDescriptorView: View {

    var descriptor: DescriptorResponse
    var onInstallLink: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Add Descriptor")
                        .padding()
                Spacer()
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                            .padding()
                }
            }
        }

        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Image(systemName: "doc.text.fill")
                            .padding(.trailing, 10)
                    Text(descriptor.descriptor.name)
                            .bold()
                            .font(.system(size: 18))
                    Spacer()
                }
                        .padding(.bottom, 10)
                Text(String(format: "Created by %@ ", descriptor.descriptor.author))
                        .padding(.bottom, 10)
                Text(descriptor.descriptor.i_description)
                        .lineLimit(3)
                        .padding(.bottom, 10)
                HStack {
                    Text("Install updates automatically")
                    Spacer()
                    Image(systemName: "square")
                }
                HStack {
                    Spacer()
                    Text("Run automatically")
                            .font(.system(size: 14))
                }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))

                HStack {
                    Text("Tests".uppercased())
                            .bold()
                    Image(systemName: "chevron.up")
                    Spacer()
                    Image(systemName: "square")
                }
                        .padding(.bottom, 10)

                ForEach(descriptor.descriptor.nettests, id: \.self) { nettest in
                    VStack(alignment: .leading) {

                        HStack {
                            Text(nettest.test_name)
                            Image(systemName: "chevron.down")
                            Spacer()
                            Image(systemName: "square")
                        }

                        ForEach(nettest.inputs, id: \.self) { input in
                            Text(input)
                                    .lineLimit(1)
                                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 2))
                        }
                    }
                }
            }
                    .padding()
        }
                .frame(maxWidth: .infinity)

                .background(Color("color_white"))
        HStack {
            Button(action: onCancel) {

                Text("Cancel")
                        .padding()
            }
            Spacer()
            Button(action: onInstallLink) {
                Text("Install Link")
                        .foregroundColor(Color.blue)
                        .padding()
            }
        }

    }
};

class AddDescriptorController: UIViewController {

    var descriptorResponse: DescriptorResponse?


    override func viewDidLoad() {
        super.viewDidLoad()
        if let descriptor = descriptorResponse as? DescriptorResponse {

            let controller = UIHostingController(
                    rootView: AddDescriptorView(descriptor: descriptor, onInstallLink: {
                        print("Install Link")
                    }, onCancel: {
                        self.dismiss(animated: true)
                    })
            )
            addChild(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.backgroundColor = UIColor(named: "color_gray1")
            view.addSubview(controller.view)
            controller.didMove(toParent: self)
            NSLayoutConstraint.activate([
                controller.view.widthAnchor.constraint(equalTo: view.widthAnchor),
                controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
                controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        } else {
            dismiss(animated: true)
        }


    }

}
