import SwiftUI

enum AccentTheme: String, CaseIterable, Identifiable {
    case blue = "Blue"
    case red = "Red"
    case green = "Green"
    
    var id: String { self.rawValue }
    
    var primaryColor: Color {
        switch self {
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        }
    }
    
    var softBackground: Color {
        primaryColor.opacity(0.15)
    }
}

struct appSettings: View {
    var body: some View {
        topContainer()
    }
}

struct topContainer: View {
    @AppStorage("accentTheme") var themeName: String = "Blue"
    
    var selectedTheme: AccentTheme {
        AccentTheme(rawValue: themeName) ?? .blue
    }
    
    @AppStorage("showExamples") var showExamples = false

    // appVersions
    var appVersion = "1.1.1"
    
    @State private var placeholderBool1 = true
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack { /// for tint always use vstacks so it wraps the whole thing and actually works
            Text("Settings")
                .padding(25)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .dynamicTypeSize(.accessibility2)
                .fontDesign(.monospaced)
                .bold()
            
            Spacer()
            
            VStack {
                Toggle("Show example airports", isOn: $showExamples)
                    .padding()
                    .bold()
                    .dynamicTypeSize(.xxLarge)
                
                HStack {
                    Text("Color Theme")
                        .bold()
                        .dynamicTypeSize(.xxLarge)
                    
                    Spacer()
                    
                    // Bind to $themeName (String) and tag with theme.rawValue (String)
                    Picker("Color Theme", selection: $themeName) {
                        ForEach(AccentTheme.allCases) { theme in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(theme.primaryColor)
                                Text(theme.rawValue)
                            }
                            .tag(theme.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                
                Toggle("Placeholder", isOn: $placeholderBool1)
                    .padding()
                    .bold()
                    .dynamicTypeSize(.xxLarge)
            }
            
            Spacer()
            
            Text("Created by @Fluffbyte57 on [GitHub](https://github.com/fluffbyte57/METAR-decoder-2)")
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Version \(appVersion)")
                .dynamicTypeSize(.xSmall)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .tint(selectedTheme.primaryColor)
    }
}

#Preview {
    appSettings()
}
