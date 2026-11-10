import SwiftUI
import Playgrounds

///helloworlddd2
///
///
extension String{
    static let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
}

@Observable
class AppState{
    var metarText: String = ""
}
// Observable basically makes it be avaulable to the entire app

struct ContentView: View {
    var body: some View {
        @State var appState = AppState()
        //appstate.metarText can be used to "inject" the variable
        TopContainer()
        DescriptionContainer()
        MetarField()
        Spacer()
        VStack{
        }
    }
}

struct MetarField: View {
    var body: some View {
        @State var appState = AppState()
        VStack{
            TextField("Type your METAR here...", text: $appState.metarText)
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
