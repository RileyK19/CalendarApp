//
//  Events.swift
//  testmar7
//
//  Created by Riley Koo on 3/12/24.
//

import SwiftUI

struct Event : Codable {
    var status: Bool = false
    var startDate: Date
    var endDate: Date
    var title: String
    var ID: String
    func happening(date: Date) -> Bool {
        return date < endDate && date > startDate
    }
}

struct EventView: View {
    @State var event: Event
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(event.title)
                .font(.title3)
            HStack {
                Text(event.startDate, style: .time)
                    .font(.subheadline)
                    .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)
                Text(" to ")
                    .font(.subheadline)
                    .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)
                Text(event.endDate, style: .time)
                    .font(.subheadline)
                .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)            }
        }
        .padding()
        .navigationTitle("Event Details")
    }
}

struct EventListView: View {
    @State var events: [Event]
    @State var CV: ContentView
    @State var tag: String
    @State private var curName: String = ""
    @State private var curStart: Date = Date.now
    @State private var curEnd: Date = Date.now
    @State private var popup = false
    @State private var start = false
    @State private var end = false
    @State var eventsNotifIDs: [String]
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            Text(tag)
                .font(.title.bold())
            HStack{
                Spacer()
                    .frame(width: 15)
                TextField("Enter event", text: $curName)
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button{
                    popup = true
                } label: {
                    Text("+")
                }
                .popover(isPresented: $popup) {
                    VStack{
                        Spacer()
                            .frame(height: 15)
                        HStack{
                            Spacer()
                            TextField("Enter event", text: $curName)
                                .frame(alignment: .center)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 15)
                        HStack{
                            Spacer()
                                .frame(width: 15)
                            Button{
                                if end {
                                    end.toggle()
                                }
                                start.toggle()
                            } label: {
                                Text(start ? "Close" : "Start Date")
                            }
                            Spacer()
                            Text(curStart, style: .date)
                                .opacity(0.5)
                            Spacer()
                                .frame(width: 15)
                        }
                        Spacer()
                            .frame(height: 20)
                        if start {
                            DatePicker(
                                "Start Date",
                                selection: $curStart,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.graphical)
                            .frame(width: 320, height: 320)
                            .labelsHidden()
                            Spacer()
                                .frame(height: 20)
                        }
                        HStack{
                            Spacer()
                                .frame(width: 15)
                            Button{
                                if start {
                                    start.toggle()
                                }
                                end.toggle()
                            } label: {
                                Text(end ? "Close" : "End Date")
                            }
                            Spacer()
                            Text(curEnd, style: .date)
                                .opacity(0.5)
                            Spacer()
                                .frame(width: 15)
                        }
                        Spacer()
                            .frame(height: 20)
                        if end {
                            DatePicker(
                                "End Date",
                                selection: $curEnd,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.graphical)
                            .frame(width: 320, height: 320)
                            .labelsHidden()
                            Spacer()
                                .frame(height: 20)
                        }
                        Button {
                            if curEnd > curStart {
                                var eventAdd = Event(startDate: curStart, endDate: curEnd, title: curName, ID: tag)
                                events.append(eventAdd)
                                CV.events = events
                                makeNotif(event: eventAdd)
                                popup.toggle()
                                curName = ""
                                curStart = Date.now
                                curEnd = Date.now
                                start = false
                                end = false
                            }
                        } label: {
                            Text("Add event")
                        }
                        Spacer()
                            .frame(height: 20)
                        Button {
                            popup.toggle()
                        } label: {
                            Text("Close")
                        }
                    }
                }
                Spacer()
                    .frame(width: 15)
            }
            ForEach(Array(0..<events.count), id:\.self) { x in
                HStack{
                    if events[x].ID == tag && !events[x].status {
                        EventView(event: events[x])
                        Text(tag)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Button(action: {
                            events[x].status = true
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [CV.eventNotifIDs[x]])
                            CV.completed += 1
                        }, label: {
                            Image(systemName: !events[x].status ? "square" : "checkmark.square")
                        })
                        .toggleStyle(.button)
                    }
                }
            }
            Spacer()
        }
    }
    func makeNotif(event: Event){
        let text = event.title
        let content = UNMutableNotificationContent()
        content.title = "In 10 Minutes: " + text
        content.subtitle = event.ID
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: -10, to: event.startDate)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date ?? Date())
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        let ID = UUID().uuidString
        let request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
        eventsNotifIDs.append(ID)
        CV.eventNotifIDs = eventsNotifIDs
        
        UNUserNotificationCenter.current().add(request)
        
    }
}

struct MiniEventView: View {
    @State var event: Event
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(event.title)
                    .font(.callout)
                Text(event.ID)
                    .font(.footnote)
                    .opacity(0.75)
            }
            HStack {
                Text(event.startDate, style: .time)
                    .font(.footnote)
                    .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)
                Text(" to ")
                    .font(.footnote)
                    .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)
                Text(event.endDate, style: .time)
                    .font(.footnote)
                .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)            }
            }
        .padding()
        .navigationTitle("Event Details")
    }
}
