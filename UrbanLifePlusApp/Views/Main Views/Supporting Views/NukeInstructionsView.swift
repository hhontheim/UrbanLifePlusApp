//
//  NukeInstructionsView.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 17.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct NukeInstructionsView: View {
    var body: some View {
        VStack {
            Text("login.revokeSIWAInSettings.instructions.title")
                .font(.headline)
                .padding(.bottom, 12)
            VStack(alignment: .leading) {
                ForEach(1..<8) { i in
                    InstructionRow(no: i)
                        .padding(.top, 12)
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

struct InstructionRow: View {
    @State var no: Int
    @State var stringLiteral: String = "login.revokeSIWAInSettings.instructions.text."
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(no).")
            Text(LocalizedStringKey(stringLiteral: stringLiteral))
        }
        .onAppear {
            self.stringLiteral.append("\(self.no)")
        }
    }
}

struct NukeInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        NukeInstructionsView()
    }
}
