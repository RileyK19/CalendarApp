//
//  ContentView.swift
//  testmar7
//
//  Created by Riley Koo on 3/7/24.
//


// Calendar View + some assets from Kavsoft's Custom Date Picker Tutorial
// https://www.youtube.com/watch?v=UZI2dvLoPr8

import SwiftUI

struct ContentView: View {
    @SceneStorage("ContentView.todos") var todos: [Todo] = []
    @SceneStorage("ContentView.toggles") var toggles: [Bool] = []
    @SceneStorage("ContentView.notifIDs") var notifIDs: [String] = []
    
    @SceneStorage("ContentView.pushNotifs") var pushNotifs: Bool = false
    @SceneStorage("ContentView.names") var names: [String] = []
    
    
    @State var curName = ""
    let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @State var currentDate: Date = Date.now
    @State var currentMonth = 0
    @State var tasksPopover = false
    
    @SceneStorage("ContentView.events") var events: [Event] = []
    @SceneStorage("ContentView.eventsNames") var eventsNames: [String] = []
    @State var curEventName = ""
    @SceneStorage("ContentView.eventNotifIDs") var eventNotifIDs: [String] = []
    
    @SceneStorage("ContentView.completed") var completed: Int = 0
    
    @State var completedPopup = false
    @State var completedPopupEvent = false
    
    @State var alertsTodos: [Bool] = [false]
    @State var alertsEvents: [Bool] = [false]
    
    @State var settings = false
    
    @SceneStorage("ContentView.authenticate") var needAuth = false
    
    @State var dayViewPopover: Bool = false
    
    @State var tmpText: String = "" // for home page
    @State var ToggleLists = false
    
    var body: some View {
        if !pushNotifs {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        pushNotifs = true
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        else if settings {
            OptionsView(CV: self)
                .transition( .move(edge: .leading))
        }
        else {
            tabs
        }
    }
    
    var tabs: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 15)
                Button {
                    withAnimation {
                        settings.toggle()
                    }
                } label: {
                    Image(systemName: "gearshape")
                        .padding(0)
                }
                Spacer()
            }
            TabView {
                listsView
                    .tabItem({
                        Image(systemName: "list.dash")
                        Text("Lists")
                    })
                eventsView
                    .tabItem({
                        Image(systemName: "note.text.badge.plus")
                        Text("Events")
                    })
                calendarBody
                    .tabItem({
                        Image(systemName: "calendar.badge.clock.rtl")
                        Text("Calendar")
                    })
                JournalView(CV: self)
                    .tabItem {
                        Image(systemName: "book")
                        Text("Journals")
                    }
            }
            .onAppear{
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
    }
}
