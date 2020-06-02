//
//  UrbanLifePlusAppUITests.swift
//  UrbanLifePlusAppUITests
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import XCTest

class UrbanLifePlusAppUITests: XCTestCase {
    
    var app: XCUIApplication = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        
        setupSnapshot(app)
        app.launch()
        
        addUIInterruptionMonitor(withDescription: "System Dialog") {
            (alert) -> Bool in
            let okButton = alert.buttons["OK"]
            if okButton.exists {
                okButton.tap()
            }
            let allowButton = alert.buttons["Allow"]
            if allowButton.exists {
                allowButton.tap()
            }
            let jaButton = alert.buttons["Ja"]
            if jaButton.exists {
                jaButton.tap()
            }
            let erlaubenButton = alert.buttons["Erlauben"]
            if erlaubenButton.exists {
              erlaubenButton.tap()
            }
            
            return true
        }
    }
    
    func testSnapshots() {
        snapshot("01 - Notification")

        app.navigationBars["Hallo!"].staticTexts["Hallo!"].tap()
        app.navigationBars["Hallo!"].staticTexts["Hallo!"].tap()
        
        snapshot("02 - LogInView (kein Account)")

        app.buttons["Sign up with Apple"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Startseite"].tap()
        
        snapshot("03 - Startseite")
        
        tabBarsQuery.buttons["Präferenzen"].tap()
        
        snapshot("04 - Präferenzen")

        tabBarsQuery.buttons["Einstellungen"].tap()
        
        snapshot("05 - Einstellungen")
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Mein Profil verwalten"]/*[[".cells.buttons[\"Mein Profil verwalten\"]",".buttons[\"Mein Profil verwalten\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        snapshot("06 - ProfileView")
        
        tabBarsQuery.buttons["Präferenzen"].tap()
        tabBarsQuery.buttons["Einstellungen"].tap()

        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Entwickler Menü"]/*[[".cells.buttons[\"Entwickler Menü\"]",".buttons[\"Entwickler Menü\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        snapshot("07 - DevView")
        
        tabBarsQuery.buttons["Präferenzen"].tap()
        tabBarsQuery.buttons["Einstellungen"].tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Hilfe..."]/*[[".cells.buttons[\"Hilfe...\"]",".buttons[\"Hilfe...\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        snapshot("08 - HelpSheet")
        
        app.sheets["Womit können wir helfen?"].scrollViews.otherElements.buttons["Abbrechen"].tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Abmelden"]/*[[".cells.buttons[\"Abmelden\"]",".buttons[\"Abmelden\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        snapshot("09 - LogInView (Account eingerichtet)")
        
        app.buttons["Continue with Apple"].tap()
        
        tabBarsQuery.buttons["Präferenzen"].tap()
        tabBarsQuery.buttons["Einstellungen"].tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Alle Daten löschen..."]/*[[".cells.buttons[\"Alle Daten löschen...\"]",".buttons[\"Alle Daten löschen...\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        snapshot("10 - NukeShield")
        
        app.sheets["Möchtest Du wirklich alle Daten der App löschen?"].scrollViews.otherElements.buttons["Ja, Daten löschen!"].tap()
        
        snapshot("11 - Nuked View")
    }
    
//    func test22() {
//        app.buttons["Sign up with Apple"].tap()
//        app.tabBars.buttons["Einstellungen"].tap()
//        app.tables.buttons["Abmelden"].tap()
//        app.buttons["Continue with Apple"].tap()
//    }
}
