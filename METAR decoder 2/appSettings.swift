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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack{
            Button(action: {dismiss()}){
                Image(systemName: "chevron.backward")
                    .dynamicTypeSize(.xxLarge)
                    .bold()
                    .padding()
                    .frame(width: 25, height:25)
                    //.glassEffect(.clear)
            }
            Text("Settings")
                .padding()
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .dynamicTypeSize(.xxxLarge)
                .fontDesign(.monospaced)
        }
        Spacer()
    }
}

#Preview {
    appSettings()
}
