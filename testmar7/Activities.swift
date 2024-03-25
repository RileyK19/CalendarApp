//
//  Activities.swift
//  testmar7
//
//  Created by Riley Koo on 3/23/24.
//

import SwiftUI

@Observable
class Activity: Encodable, Decodable, Equatable {
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return (lhs.title == rhs.title &&
        lhs.ID == rhs.ID &&
        lhs.start == rhs.start &&
        lhs.end == rhs.end &&
        lhs.done == rhs.done)
    }
    
    var title: String
    var ID: String
    var start: Date
    var end: Date
    var notifID: [String]
    var done: Bool
    init(title: String, ID: String, start: Date, end: Date) {
        self.title = title
        self.ID = ID
        self.start = start
        self.end = end
        self.notifID = []
        self.done = false
    }
    func removeNotifs() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notifID)
    }
}

struct ActivityView: View {
    @State var event: Activity
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(event.title)
                    .font(.title3)
                Text(event.ID)
                    .font(.subheadline)
            }
            HStack {
                Text(event.start, style: .time)
                    .font(.subheadline)
                    .foregroundColor((event.start < Date.now && event.end > Date.now ) ? .green : .gray)
                Text(" to ")
                    .font(.subheadline)
                    .foregroundColor((event.start < Date.now && event.end > Date.now ) ? .green : .gray)
                Text(event.end, style: .time)
                    .font(.subheadline)
                .foregroundColor((event.start < Date.now && event.end > Date.now ) ? .green : .gray)
            }
        }
        .padding()
    }
}

func makeNotif(activity: Activity) -> [String] {
    var ret: [String] = []
    
    let text = activity.title
    let content = UNMutableNotificationContent()
    content.title = "In 10 Minutes: " + text
    content.subtitle = activity.ID
    content.sound = UNNotificationSound.default
    
    let calendar = Calendar.current
    var date = calendar.date(byAdding: .minute, value: -10, to: activity.start)
    var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date ?? Date())
    
    var trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents,
        repeats: false
    )
    var ID = UUID().uuidString
    var request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
    ret.append(ID)
    
    UNUserNotificationCenter.current().add(request)
    
    content.title = "Starting now: " + text
    
    date = activity.start
    dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date ?? Date())
    
    trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents,
        repeats: false
    )
    ID = UUID().uuidString
    request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
    ret.append(ID)
    
    UNUserNotificationCenter.current().add(request)
    
    if activity.end > calendar.date(byAdding: .minute, value: 10, to: activity.start)! {
        content.title = "Ending in 10 minutes: " + text
        
        date = calendar.date(byAdding: .minute, value: -10, to: activity.end)
        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date ?? Date())
        
        trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        ID = UUID().uuidString
        request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
        ret.append(ID)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    
    content.title = "Ending now: " + text
    
    date = activity.end
    dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date ?? Date())
    
    trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents,
        repeats: false
    )
    ID = UUID().uuidString
    request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
    ret.append(ID)
    
    UNUserNotificationCenter.current().add(request)
    
    return ret
}
