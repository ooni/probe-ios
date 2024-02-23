import SwiftUI

struct LaunchScreen: View {

    @State private var isLoading = true
    @State private var descriptorResponse: DescriptorResponse?

    var body: some View {
        VStack {
            if isLoading {
                LoadingView()
            } else {
                AddDescriptorScreen(descriptorResponse: descriptorResponse!)
            }
        }
                .onAppear {
                    DispatchQueue.global().async {
                        TestDescriptorManager.fetchDescriptor(
                                fromRunId: 118518729102, onSuccess: {
                            (response: DescriptorResponse) in
                            DispatchQueue.main.async {
                                descriptorResponse = response
                                isLoading = false
                            }
                        }) { (error: Error) in
                            print(error)
                        }
                    }
                }
    }
}

struct LoadingView: View {
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
                    Button(action: {}) {
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

#Preview {
    LaunchScreen()
}
