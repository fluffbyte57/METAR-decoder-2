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
    var metarText: String = "KORD 251751Z 24015G25KT 3SM -RA BR BKN012 OVC025 14/11 A2992 RMK AO2 RAB32 SLP134"
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
        
        var decodedMETAR = parseMETAR(appState.metarText)
        
        VStack{
            TextField("Type your METAR here...", text: $appState.metarText)
                .multilineTextAlignment(.center)
            //.background()
                .cornerRadius(15)
                .frame(width: 400 , height: 37)
                .dynamicTypeSize(.accessibility1)
                .glassEffect(.clear)
            Button(action: {print("Current METAR: ", decodedMETAR)}){
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
    func parseMETAR(_ rawText: String) -> decodedMETAR {
            var result = decodedMETAR()
            
            // Clean up extra spaces and make everything uppercase
            let cleaned = rawText.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if cleaned.isEmpty { return result }
            
            // Step A: Separate Remarks ("RMK") first so it doesn't confuse the main parser
            let mainAndRemarks = cleaned.components(separatedBy: " RMK ")
            let mainPart = mainAndRemarks[0]
            if mainAndRemarks.count > 1 {
                result.remarks = mainAndRemarks[1]
            }
            
            // Step B: Splice the main report into individual words (tokens)
            let tokens = mainPart.components(separatedBy: " ")
            
            // Step C: Loop through every token and check its format using Regex
            for (index, token) in tokens.enumerated() {
                
                // 1. Station ID: First 4-letter word (ignoring "METAR" or "SPECI")
                if (index == 0 || index == 1), token.wholeMatch(of: /^[A-Z]{4}$/) != nil, token != "METAR", token != "SPECI" {
                    result.station = token
                }
                
                // 2. Time: 2 digits for day, 4 digits for UTC time, ending in Z (e.g., 112053Z)
                else if let match = token.wholeMatch(of: /^(\d{2})(\d{2})(\d{2})Z$/) {
                    result.time = "Day \(match.1) at \(match.2):\(match.3) UTC"
                }
                
                // 3. Wind: 3 digits direction (or VRB), 2-3 digits speed, optional Gust, ending in KT
                else if let match = token.wholeMatch(of: /^(\d{3}|VRB)(\d{2,3})(?:G(\d{2,3}))?KT$/) {
                    let dir = match.1 == "VRB" ? "Variable" : "\(match.1)°"
                    let speed = "\(Int(match.2) ?? 0) kts"
                    if let gust = match.3 {
                        result.wind = "\(dir) at \(speed), gusting \(Int(gust) ?? 0) kts"
                    } else {
                        result.wind = "\(dir) at \(speed)"
                    }
                }
                
                // 4. Visibility: Ends with SM (e.g., 10SM or 3SM)
                else if let match = token.wholeMatch(of: /^(\d+(?:\/\d+)?)SM$/) {
                    result.visibility = "\(match.1) statute miles"
                }
                
                // 5. Sky Condition: Coverage code + 3 digits for altitude in hundreds of feet
                else if let match = token.wholeMatch(of: /^(FEW|SCT|BKN|OVC)(\d{3})$/) {
                    let coverNames = ["FEW": "Few", "SCT": "Scattered", "BKN": "Broken", "OVC": "Overcast"]
                    let cover = coverNames[String(match.1)] ?? String(match.1)
                    let altitude = (Int(match.2) ?? 0) * 100
                    result.clouds.append("\(cover) at \(altitude) ft")
                }
                
                // 6. Temp / Dew Point: Two digits (optional M for minus) separated by a slash
                else if let match = token.wholeMatch(of: /^(M?\d{2})\/(M?\d{2})$/) {
                    let temp = match.1.replacingOccurrences(of: "M", with: "-")
                    let dew = match.2.replacingOccurrences(of: "M", with: "-")
                    result.temperature = "\(temp)°C / \(dew)°C"
                }
                
                // 7. Altimeter: Starts with A followed by 4 digits (e.g., A3004 -> 30.04)
                else if let match = token.wholeMatch(of: /^A(\d{2})(\d{2})$/) {
                    result.altimeter = "\(match.1).\(match.2) inHg"
                }
                
                // 8. Basic Weather Phenomena (Rain, Snow, Mist, Fog, Thunderstorm)
                else if token.wholeMatch(of: /^(-|\+|VC)?(DZ|RA|SN|TS|BR|FG|HZ)+$/) != nil {
                    result.weather.append(decodeWeatherCode(token))
                }
            }
            
            return result
        }
    
}
func decodeWeatherCode(_ code: String) -> String {
        var text = code
        text = text.replacingOccurrences(of: "-", with: "Light ")
        text = text.replacingOccurrences(of: "+", with: "Heavy ")
        text = text.replacingOccurrences(of: "VC", with: "Nearby ")
        text = text.replacingOccurrences(of: "TS", with: "Thunderstorm ")
        text = text.replacingOccurrences(of: "RA", with: "Rain ")
        text = text.replacingOccurrences(of: "SN", with: "Snow ")
        text = text.replacingOccurrences(of: "DZ", with: "Drizzle ")
        text = text.replacingOccurrences(of: "BR", with: "Mist ")
        text = text.replacingOccurrences(of: "FG", with: "Fog ")
        text = text.replacingOccurrences(of: "HZ", with: "Haze ")
        return text.trimmingCharacters(in: .whitespaces)
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
