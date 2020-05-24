//
//  PreferencesList.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 24.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI

struct PreferencesList: View {
    @EnvironmentObject var storage: Storage
    
    let showDummyData: Bool = true
    
    #if os(iOS)
    let dummyData: [DummyDevice] = [
        DummyDevice(name: "Ampelanlage", preferences: [
            DummyPreference(name: "Längere Grünphasen")
        ], image: "car.fill"),
        DummyDevice(name: "ÖPNV", preferences: [
            DummyPreference(name: "Fahrzeuge sollen Rampe ausklappen")
        ], image: "tram.fill"),
        DummyDevice(name: "Straßenlaterne", preferences: [
            DummyPreference(name: "Helleres Licht"),
            DummyPreference(name: "Wegweiser bei Navigation anzeigen")
        ], image: "sun.max.fill")
    ]
    #elseif os(watchOS)
    let dummyData: [DummyDevice] = [
        DummyDevice(name: "Ampelanlage", preferences: [
            DummyPreference(name: "Längere Grün-\nphasen")
        ], image: "car.fill"),
        DummyDevice(name: "ÖPNV", preferences: [
            DummyPreference(name: "Fahrzeug soll Rampe aus-\nklappen")
        ], image: "tram.fill"),
        DummyDevice(name: "Straßenlaterne", preferences: [
            DummyPreference(name: "Helleres Licht"),
            DummyPreference(name: "Wegweiser bei Navigation anzeigen")
        ], image: "sun.max.fill")
    ]
    #endif
    
    var body: some View {
        let bUserWantsLEDOn = Binding(
            get: { self.storage.bluetooth.userWantsLEDOn },
            set: {
                self.storage.bluetooth.userWantsLEDOn = $0
                self.storage.persist()
        }
        )
        
        return List {
            Section(header: PreferenceHeader(image: "lightbulb.fill", text: Text("bt.dev.demo"))) {
                Toggle(isOn: bUserWantsLEDOn) {
                    #if os(iOS)
                    Text("bt.dev.demo.led")
                    #elseif os(watchOS)
                    Text("bt.dev.demo.led")
                        .padding()
                    #endif
                }
            }
            if showDummyData {
                ForEach(dummyData) { d in
                    Section(header:
                        HStack {
                            PreferenceHeader(image: d.image, text: Text("\(d.name)"))
                            #if !os(watchOS)
                            Spacer()
                            Text("bt.dummy")
                            #endif
                    }) {
                        ForEach(d.preferences) { pref in
                            Toggle(isOn: pref.$toggle) {
                                #if os(iOS)
                                Text("\(pref.name)")
                                #elseif os(watchOS)
                                Text("\(pref.name)")
                                    .padding()
                                #endif
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DummyDevice: Identifiable {
    var id = UUID()
    var name: String
    var preferences: [DummyPreference]
    var image: String
}

struct DummyPreference: Identifiable {
    var id = UUID()
    var name: String
    
    @State var toggle: Bool = false
}
