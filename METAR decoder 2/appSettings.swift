//
//  appSettings.swift
//  METAR decoder 2
//
//  Created by Yacov Daki on 11/11/26.
//

import SwiftUI

struct appSettings: View {
    
    var body: some View {
        topContainer()
    }
}

struct topContainer: View {
    
    //appVersions
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    
    @State private var placeholderBool1 = true
    @Environment(\.dismiss) var dismiss

    var body: some View {
            Text("Settings")
                .padding()
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .dynamicTypeSize(.accessibility2)
                .fontDesign(.monospaced)
                .bold()
        Spacer()
        VStack{
            Toggle("Placeholder", isOn: $placeholderBool1)
                .padding()
                .bold()
                .dynamicTypeSize(.xxLarge)
            Toggle("Placeholder", isOn: $placeholderBool1)
                .padding()
                .bold()
                .dynamicTypeSize(.xxLarge)
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
}

#Preview {
    appSettings()
}
