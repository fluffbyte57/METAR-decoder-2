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

//@State var appState = AppState()

struct decodedMETAR{
    var station: String = "Unknown"
    var time: String = "Unknown"
    var wind: String = "Unknown"
    var visibility: String = "Unknown"
    var weather: [String] = []
    var clouds: [String] = []
    var temperature: String = "Unknown"
    var altimeter: String = "Unknown"
    var remarks: String = "Unknown"
}


struct ContentView: View {
    @State var appState = AppState()
    
    var body: some View {
        //appstate.metarText can be used to "inject" the variable
        TopContainer(appState: appState)
        DescriptionContainer()
        MetarField(appState: appState)
        Spacer()
        VStack{
        }
    }
}

struct MetarField: View {
    @Bindable var appState = AppState()

    var body: some View {
        VStack{
            TextField("Type your METAR here...", text: $appState.metarText)
                .multilineTextAlignment(.center)
                //.background()
                .cornerRadius(15)
                .frame(width: 400 , height: 37)
                .dynamicTypeSize(.accessibility1)
                .glassEffect(.clear)
            Button(action: {print("Current METAR: ", appState.metarText)}){
                Text("Convert")
                    .bold()
                    .dynamicTypeSize(.xxLarge)
                    .fontDesign(.rounded)
                    .frame(width: 100, height: 30)
                    .glassEffect(.clear)
                    .padding()
            }
        }
    }
}

struct TopContainer: View{
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Bindable var appState = AppState()
    @State private var showingSettings = false
    
    var body: some View {
        HStack{
            Button(action: {if isDarkMode == true{
                isDarkMode = false
            }else if isDarkMode == false{
                isDarkMode = true
            }}){
                Image(systemName: "moon.fill")
                    .dynamicTypeSize(.large)
                .padding()
            }
            Text("METAR Decoder")
                .padding()
                .dynamicTypeSize(.xxxLarge)
                .fontDesign(.monospaced)
                .lineLimit(1)
                //.truncationMode(.middle)
            Button(action: {showingSettings = true}){
                Image(systemName: "gearshape.fill")
                    .dynamicTypeSize(.large)
                    .padding()
            }
            .sheet(isPresented: $showingSettings){
                appSettings()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
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
