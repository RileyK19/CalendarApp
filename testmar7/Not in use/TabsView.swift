////
////  TabsView.swift
////  testmar7
////
////  Created by Riley Koo on 3/18/24.
////
//
//import SwiftUI
//
//extension ContentView{
//    
//    var tabs: some View {
//        VStack {
//            HStack {
//                Spacer()
//                    .frame(width: 15)
//                Button {
//                    withAnimation {
//                        settings.toggle()
//                    }
//                } label: {
//                    Image(systemName: "gearshape")
//                        .padding(0)
//                }
//                Spacer()
//            }
//            TabView {
//                listsView
//                    .tabItem({
//                        Image(systemName: "list.dash")
//                        Text("Lists")
//                    })
//                eventsView
//                    .tabItem({
//                        Image(systemName: "note.text.badge.plus")
//                        Text("Events")
//                    })
//                calendarBody
//                    .tabItem({
//                        Image(systemName: "calendar.badge.clock.rtl")
//                        Text("Calendar")
//                    })
//                JournalView(CV: self)
//                    .tabItem {
//                        Image(systemName: "book")
//                        Text("Journals")
//                    }
//            }
//            .onAppear{
//                UIApplication.shared.applicationIconBadgeNumber = 0
//            }
//        }
//    }
//}
