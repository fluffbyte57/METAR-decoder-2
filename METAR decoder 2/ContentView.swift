import SwiftUI
import Playgrounds

///helloworlddd2
///
///
extension String{
    static let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
}

struct ContentView: View {
    var body: some View {
        TopContainer()
        DescriptionContainer()
        Spacer()
        VStack{
        }

    }
}

struct TopContainer: View{
    var body: some View {
        HStack{
            Button(action: {print("pressed lightDark switch")}){
                Image(systemName: "moon.fill")
                    .dynamicTypeSize(.large)
                .padding()
            }
            Text("METAR Decoder")
                .padding()
                .dynamicTypeSize(.xxLarge)
                .fontDesign(.monospaced)
                .lineLimit(1)
                //.truncationMode(.middle)
            Button(action: {print("pressed settings")}){
                Image(systemName: "gearshape.fill")
                    .dynamicTypeSize(.large)
                    .padding()
            }

        }
    }
}

struct DescriptionContainer: View {
    var body: some View {
        Text(verbatim: .loremIpsum)
            .fontWeight(.thin)
            .multilineTextAlignment(.center)
    }
}



#Preview {
    ContentView()
}
