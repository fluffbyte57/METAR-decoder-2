import SwiftUI
import Playgrounds


//remember add placeholder METARs for user to try out (COMPLETEEEEEEE)
//keep warning label showing on FALSE during testing because its annoying af

///helloworlddd2
///
///


@Observable
class AppState{
    var metarText: String = ""
    var KMIA_METAR: String = "METAR KMIA 202253Z 18003KT 10SM FEW030 FEW200 FEW250 26/22 A2989 RMK AO2 SLP121 T02560222 $"
    var KJFK_METAR: String = "METAR KJFK 202251Z 19005KT 10SM FEW250 13/08 A3028 RMK SLP252 T01280078 $"
    var KFLL_METAR: String = "METAR KFLL 182053Z 11024G33KT 8SM -RA SCT021 BKN035 OVC110 23/21 A2999 RMK AO2 PK WND 10033/2052 RAB14 SLP156 P0002 60003 T02330206 58004 $"
    var KLAX_METAR: String = "METAR KLAX 202253Z 25009KT 10SM FEW035 FEW080 18/03 A2996 RMK AO2 SLP146 T01780033 $"
    var currentMETAR = decodedMETAR()
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
    @AppStorage("accentTheme") var themeName: String = "Blue"
    
    var selectedTheme: AccentTheme{
        AccentTheme(rawValue: themeName) ?? .blue
    }

    @AppStorage("showExamples") var showExamples = false
    @State var showingWarningLabel = false
    @State var appState = AppState()
    
    var body: some View {
        VStack{
            
            //appstate.metarText can be used to "inject" the variable
            TopContainer(appState: appState)
            DescriptionContainer()
            
            //MetarField(appState: appState)
            newMETARfield()
            if showExamples == true{
                exampleField()
        }
        }
        .tint(selectedTheme.primaryColor)
        //warningField()
        //Instead of constant warning field, make a popup on app start warning user
        Spacer()
        VStack{
        }
        .sheet(isPresented: $showingWarningLabel) {
            Spacer()
            VStack{
                Text("⚠️ WARNING ⚠️")
                    .bold()
                    .dynamicTypeSize(.accessibility2)
                Text("The converter may contian errors and it should not be used as a replacement to pilot thinking. This app is only intended for educational / partial navigational use. Important details should always be double-checked")
                /// Warn user that app may contian errors and that it shouldn´t be a replacement to pilot thinking
                    .multilineTextAlignment(.center)
                    .dynamicTypeSize(.xxLarge)
                    .padding()
            }
            
            ///REMEMBER TO CHANGE BEFORE COMMITING
            
            Button(action: {showingWarningLabel = true}){
                Text("Accept")
                    .padding()
                    .frame(width: 100, height: 50)
                    .glassEffect(.clear)
                    .dynamicTypeSize(.xLarge)
                    .bold()
            }
            
            Spacer()
            .interactiveDismissDisabled()

        }
    }
}



struct newMETARfield: View{
    @AppStorage("accentTheme") var selectedTheme: AccentTheme = .blue
    @Bindable var appState = AppState()
    @FocusState var isTyping: Bool
    @State var currentMETAR = decodedMETAR()
    var body: some View{
        VStack(spacing: 15){
            TextField("Type your METAR here...", text: $appState.metarText)
                .focused($isTyping)
                .textFieldStyle(.roundedBorder)
                .frame(width: 375, height: 35)
                .glassEffect(.clear)
                //.padding(.top)
            Button("Convert", action: {isTyping = false; currentMETAR = parseMETAR(appState.metarText)})
                .dynamicTypeSize(.xxLarge)
                .bold()
                .frame(width: 100, height: 30)
                .glassEffect(.clear)
        }
        VStack(alignment: .leading, spacing: 20){
            HStack{
                Image(systemName: "airplane")
                Text("Airport: \(currentMETAR.station)")
                Spacer()
            }
            HStack{
                Image(systemName: "clock")
                Text("Time: \(currentMETAR.time)")
            }
            HStack{
                Image(systemName: "wind")
                Text("Winds: \(currentMETAR.wind)")
            }
            HStack{
                Image(systemName: "eye")
                Text("Visibility: \(currentMETAR.visibility)")
            }
            HStack{
                Image(systemName: "cloud.sun")
                Text("Weather: \(currentMETAR.weather)")

            }
            HStack{
                Image(systemName: "cloud")
                Text("Clouds: \(currentMETAR.clouds)")

            }
            HStack{
                Image(systemName: "thermometer")
                Text("Temperature: \(currentMETAR.temperature)")

            }
            HStack{
                Image(systemName: "barometer")
                Text("Altimeter: \(currentMETAR.altimeter)")
            }

            HStack{
                Image(systemName: "info.circle")
                Text("Remarks: \(currentMETAR.remarks)")

            }
            
        }
        .padding(20)
        .frame(width: 350, height: 400)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(radius: 15)
        .padding(10)
    }
    
}

struct exampleField: View {
    @Bindable var appState = AppState()
    @State var currentMETAR = decodedMETAR()

    var body: some View {
        VStack(alignment: .center, spacing: 7){
            Button(action: {currentMETAR = parseMETAR(appState.KMIA_METAR);print(currentMETAR)}){
                Text("KMIA METAR example")}
            
            Button(action: {currentMETAR = parseMETAR(appState.KJFK_METAR);print(currentMETAR)}){
                Text("KJFK METAR example")
                }
            Button(action: {currentMETAR = parseMETAR(appState.KFLL_METAR);print(currentMETAR)}){
                Text("KFLL METAR example")
                }
            Button(action: {currentMETAR = parseMETAR(appState.KLAX_METAR);print(currentMETAR)}){
                Text("KLAX METAR example")
                }
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
                    .padding(.top)
                    .padding(.horizontal)
            }
            Text("METAR Decoder")
                .padding(.top)
                .dynamicTypeSize(.accessibility1)
                .fontDesign(.monospaced)
                .lineLimit(1)
                .padding(.horizontal)

                //.truncationMode(.middle)
            Button(action: {showingSettings = true}){
                Image(systemName: "gearshape.fill")
                    .dynamicTypeSize(.large)
                    .padding(.top)
                    .padding(.horizontal)
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
        Text("METAR is the weather report that pilots get and is encoded in such a way that some training is necessary to learn to read it. This app will help you understand your local METAR report. Always double-check important info.")
            .fontWeight(.thin)
            
            .dynamicTypeSize(.small)
            .multilineTextAlignment(.center)
        
    }
    
}



#Preview {
    ContentView()
}

///hello world texttest??
///why bdont it workkkk
///bruhhhh whatever
