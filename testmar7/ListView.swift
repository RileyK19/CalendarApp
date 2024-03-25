//
//  ListView.swift
//  testmar7
//
//  Created by Riley Koo on 3/23/24.
//

import SwiftUI

enum ReminderType {
    case Reminder, Activity
    func getType() -> String{
        switch self {
        case .Reminder:
            return "Reminder"
        case .Activity:
            return "Activity"
        default:
            return ""
        }
    }
}

struct RemindList: View {
    @Binding var RemindersB: [Reminder]
    @Binding var ActivitiesB: [Activity]
    @State var Reminders: [Reminder] = []
    @State var Activities: [Activity] = []
    var ID: String
    @State var popup = false
    
    @State private var title = ""
    @State private var type: ReminderType = .Reminder
    @State private var date1 = Date.now
    @State private var date2 = Date.now
    @State private var intv = Interval.None
    
    @State var color: Color
    
    var RemindListView: some View {
        VStack {
            Spacer()
                .frame(height: 35)
            Text(ID)
                .font(.title2.bold())
                .foregroundStyle((color != Color.white) ? Color.white : Color.black)
            Spacer()
            Text("Items: " + String(Reminders.count + Activities.count))
                .font(.title3)
                .foregroundStyle((color != Color.white) ? Color.white : Color.black)
            Spacer()
                .frame(height: 35)
        }
        .frame(width: 350, height: 100)
        .background(
//            RoundedRectangle(cornerRadius: 25)
//                .foregroundStyle(color)
//                .frame(width: 350, height: 100)
            CustomBackground(color: color, opac: 1.0)
        )
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 75)
            Text(ID)
                .font(.title.bold())
                .onAppear {
                    Activities = ActivitiesB
                    Reminders = RemindersB
                }
                .onDisappear {
                    ActivitiesB = Activities
                    RemindersB = Reminders
                }
            Spacer()
                .frame(height: 75)
            Button {
                popup = true
            } label :{
                Image(systemName: "plus.app")
                    .background(
//                        RoundedRectangle(cornerRadius: 20)
//                            .foregroundStyle(Color(.systemGroupedBackground))
//                            .frame(width: 350, height: 100)
                        CustomBackground(color: Color(.systemGroupedBackground), opac: 1.0)
                    )
            }
            Spacer()
                .frame(height: 20)
            .popover(isPresented: $popup){
                VStack {
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                        TextField("Enter Reminder Name", text: $title)
                            .frame(alignment: .leading)
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        Menu {
                            Button("Reminder") {
                                type = .Reminder
                            }
                            Button("Activity") {
                                type = .Activity
                            }
                        } label: {
                            Text ("Type")
                        }
                        Spacer()
                        Text(type.getType())
                        Spacer()
                            .frame(width: 20)
                    }
                    Spacer()
                        .frame(height: 20)
                    switch type {
                    case .Reminder:
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                Text("Date")
                                Spacer()
                                DatePicker (
                                    "Date",
                                    selection: $date1,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .datePickerStyle(.compact)
                                Spacer()
                                    .frame(width: 20)
                            }
                            Spacer()
                                .frame(height: 20)
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                Menu {
                                    Button("None") {
                                        intv = .None
                                    }
                                    Button("Hourly") {
                                        intv = .Hourly
                                    }
                                    Button("Daily") {
                                        intv = .Daily
                                    }
                                    Button("Weekly") {
                                        intv = .Weekly
                                    }
                                    Button("Monthly") {
                                        intv = .Monthly
                                    }
                                } label: {
                                    Text("Interval")
                                }
                                Spacer()
                                if intv == Interval.None {
                                    Text("None")
                                } else if intv == Interval.Hourly {
                                    Text("Hourly")
                                } else if intv == Interval.Daily {
                                    Text("Daily")
                                } else if intv == Interval.Weekly {
                                    Text("Weekly")
                                } else if intv == Interval.Monthly {
                                    Text("Monthly")
                                }
                                Spacer()
                                    .frame(width: 20)
                            }
                            Spacer()
                                .frame(height: 20)
                        }
                    case .Activity:
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                Text("Start date")
                                Spacer()
                                DatePicker (
                                    "Start",
                                    selection: $date1,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                Spacer()
                                    .frame(width: 20)
                            }
                            Spacer()
                                .frame(height: 20)
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                Text("End date")
                                Spacer()
                                DatePicker (
                                    "End",
                                    selection: $date2,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                Spacer()
                                    .frame(width: 20)
                            }
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                    HStack {
                        Button {
                            if title != "" {
                                switch type {
                                case .Reminder:
                                    let r = Reminder(title: title, ID: ID, date: date1, intv: intv)
                                    r.notifID += (makeNotif(reminder: r))
                                    Reminders.append(r)
                                case .Activity:
                                    let a = Activity(title: title, ID: ID, start: date1, end: date2)
                                    a.notifID += (makeNotif(activity: a))
                                    Activities.append(a)
                                }
                                title = ""
                                type = .Reminder
                                date1 = Date.now
                                date2 = Date.now
                                intv = Interval.None
                                popup = false
                            }
                        } label: {
                            Image(systemName: "plus.app")
                                .background(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .foregroundStyle(Color(.systemGroupedBackground))
//                                        .frame(width: 200, height: 50)
                                    CustomBackground(color: Color(.systemGroupedBackground), opac: 1.0)
                                )
                        }
                    }
                    Spacer()
                        .frame(height: 20)
                }
            }
            Spacer()
                .frame(height: 60)
            if Reminders.count + Activities.count < 4 {
                ScrollView {
                    Spacer()
                        .frame(height: 20)
                    ForEach(Array(0..<Activities.count), id:\.self) { x in
                        if !Activities[x].done && Activities[x].ID == ID {
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                ActivityView(event: Activities[x])
                                Spacer()
                                Button(action: {
                                    Activities[x].done = true
                                    Activities[x].removeNotifs()
                                }, label: {
                                    Image(systemName: !Activities[x].done ? "square" : "checkmark.square")
                                })
                                .toggleStyle(.button)
                                Spacer()
                                    .frame(width: 30)
                            }
                            .frame(width: 350)
                            .background(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .foregroundStyle(Color(.systemGroupedBackground))
//                                    .frame(width: 350, height: 100)
                                CustomBackground(color: Color(.systemGroupedBackground), opac: 1.0)
                            )
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                    Spacer()
                        .frame(height: 20)
                    ForEach(Array(0..<Reminders.count), id:\.self) { x in
                        if !Reminders[x].done && Reminders[x].ID == ID {
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                ReminderView(event: Reminders[x])
                                Spacer()
                                Button(action: {
                                    Reminders[x].done = true
                                    Reminders[x].removeNotifs()
                                }, label: {
                                    Image(systemName: !Reminders[x].done ? "square" : "checkmark.square")
                                })
                                .toggleStyle(.button)
                                Spacer()
                                    .frame(width: 30)
                            }
                            .frame(width: 350)
                            .background(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .foregroundStyle(Color(.systemGroupedBackground))
//                                    .frame(width: 350, height: 75)
                                CustomBackground(color: Color(.systemGroupedBackground), opac: 1.0)
                            )
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                }
                .frame(width: 350, height: 500)
                Spacer()
            } else {
                if Activities.count != 0 {
                    ScrollView {
                        Spacer()
                            .frame(height: 20)
                        ForEach(Array(0..<Activities.count), id:\.self) { x in
                            if !Activities[x].done && Activities[x].ID == ID {
                                HStack {
                                    Spacer()
                                        .frame(width: 30)
                                    ActivityView(event: Activities[x])
                                    Spacer()
                                    Button(action: {
                                        Activities[x].done = true
                                        Activities[x].removeNotifs()
                                    }, label: {
                                        Image(systemName: !Activities[x].done ? "square" : "checkmark.square")
                                    })
                                    .toggleStyle(.button)
                                    Spacer()
                                        .frame(width: 30)
                                }
                                .frame(width: 350)
                                .background(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .foregroundStyle(Color(.systemGroupedBackground))
//                                        .frame(width: 350, height: 100)
                                    CustomBackground(color: Color(.systemGroupedBackground), opac: 1.0)
                                )
                                Spacer()
                                    .frame(height: 20)
                            }
                        }
                    }
                    .frame(width: 350, height: (Reminders.count == 0) ? 500 : 250)
                    Spacer()
                        .frame(height: 20)
                }
                if Reminders.count != 0 {
                    ScrollView {
                        Spacer()
                            .frame(height: 20)
                        ForEach(Array(0..<Reminders.count), id:\.self) { x in
                            if !Reminders[x].done && Reminders[x].ID == ID {
                                HStack {
                                    Spacer()
                                        .frame(width: 30)
                                    ReminderView(event: Reminders[x])
                                    Spacer()
                                    Button(action: {
                                        Reminders[x].done = true
                                        Reminders[x].removeNotifs()
                                    }, label: {
                                        Image(systemName: !Reminders[x].done ? "square" : "checkmark.square")
                                    })
                                    .toggleStyle(.button)
                                    Spacer()
                                        .frame(width: 30)
                                }
                                .frame(width: 350)
                                .background(
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .foregroundStyle(Color(.systemGroupedBackground))
//                                        .frame(width: 350, height: 75)
                                    CustomBackground(color: Color(.systemGroupedBackground), opac: 1.0)
                                )
                                Spacer()
                                    .frame(height: 20)
                            }
                        }
                    }
                    .frame(width: 350, height: (Activities.count == 0) ? 500 : 250)
                }
                Spacer()
            }
        }
    }
    func iterate(rcode: (Reminder) -> Void, acode: (Activity) -> Void) {
        for r in Reminders {
            rcode(r)
        }
        for a in Activities {
            acode(a)
        }
    }
    mutating func addReminder(title: String, date: Date, intv: Interval) {
        let r = Reminder(title: title, ID: ID, date: date, intv: intv)
        r.notifID += (makeNotif(reminder: r))
        Reminders.append(r)
        Reminders.sort { r1, r2 in
            return r1.date < r2.date
        }
    }
    mutating func addActivity(title: String, date1: Date, date2: Date) {
        let a = Activity(title: title, ID: ID, start: date1, end: date2)
        a.notifID += (makeNotif(activity: a))
        Activities.append(a)
        Activities.sort { a1, a2 in
            return a1.start < a2.start
        }
    }
    func deleteStuff() {
        Reminders.removeAll { r in
            r.ID == ID
        }
        Activities.removeAll { a in
            a.ID == ID
        }
    }
}

extension UIColor {
    class func color(data: Data) -> UIColor {
        try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! UIColor
    }

    func encode() -> Data {
        try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}

extension Color {
    //Extension to save colors
    //https://blog.eidinger.info/from-hex-to-color-and-back-in-swiftui
    
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}


func isSameDay(date1:Date, date2:Date) -> Bool {
    let calendar = Calendar.current
    return calendar.isDate(date1, inSameDayAs: date2)
}
