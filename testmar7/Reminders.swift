//
//  Reminders.swift
//  testmar7
//
//  Created by Riley Koo on 3/16/24.
//

import SwiftUI

@Observable
class Reminder: Encodable, Decodable, Equatable {
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        return (lhs.title == rhs.title &&
        lhs.ID == rhs.ID &&
        lhs.date == rhs.date &&
        lhs.intv == rhs.intv &&
        lhs.done == rhs.done)
    }
    var title: String
    var ID: String
    var date: Date
    var notifID: [String]
    var done: Bool
    var intv: Interval
    init(title: String, ID: String, date: Date, intv: Interval) {
        self.title = title
        self.ID = ID
        self.date = date
        self.notifID = []
        self.done = false
        self.intv = intv
    }
    func removeNotifs() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notifID)
    }
}

struct ReminderView: View {
    @State var event: Reminder
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(event.title)
                    .font(.title3)
                Text(event.ID)
                    .font(.subheadline)
            }
            HStack {
                Text(event.date, style: .time)
                    .font(.subheadline)
                    .foregroundColor((event.date < Date.now ) ? .red : .gray)
            }
        }
        .padding()
    }
}

func makeNotif(reminder: Reminder) -> [String] {
    var ret: [String] = []
    let text = reminder.title
    let content = UNMutableNotificationContent()
    let calendar = Calendar.current
    let date = reminder.date
    
    let dateComp = calendar.dateComponents([.year, .month, .day, .hour, .second], from: date)
    content.title = text + " at "
    content.title += String((dateComp.hour ?? 0) % 12) + ":"
    if let tmp = dateComp.minute {
        content.title += String(tmp)
    } else {
        content.title += "00"
    }
    content.subtitle = reminder.ID
    content.sound = UNNotificationSound.default
    
    var dateComponents: DateComponents
    switch reminder.intv {
    case .Monthly:
        dateComponents = Calendar.current.dateComponents([.weekOfMonth, .weekday, .hour, .minute], from: date)
    case .Weekly:
        dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
    case .Daily:
        dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
    case .Hourly:
        dateComponents = Calendar.current.dateComponents([.minute], from: date)
    default:
        dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
    }
    
    let trigger = UNCalendarNotificationTrigger(
        dateMatching: dateComponents,
        repeats: (reminder.intv != .None)
    )
    let ID = UUID().uuidString
    let request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
    ret.append(ID)
    
    UNUserNotificationCenter.current().add(request)
    
    return ret
}
