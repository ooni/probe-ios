
import SwiftUI

struct AddDescriptorScreen: View {
    let descriptorResponse: DescriptorResponse

    var body: some View {
        VStack{
            Text("Add Descriptor Screen")
            Text(descriptorResponse.descriptor.author)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddDescriptorScreen(descriptorResponse: DescriptorResponse())
    }
}
