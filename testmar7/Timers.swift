//
//  Timers.swift
//  testmar7
//
//  Created by Riley Koo on 3/20/24.
//

import SwiftUI

struct TimerListView : View {
    @Binding var timers: [TimerStruct]
    @State var popup = false
    var body : some View {
        VStack {
            Text("Timers")
                .font(.title.bold())
            Spacer()
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
            .onAppear {
                for x in 0..<timers.count {
                    if timers[x].endTime < Date.now {
                        timers[x].done = true
                    }
                }
            }
            Spacer()
                .frame(height: 20)
                .popover(isPresented: $popup){
                    TimerPopup(popup: $popup, timers: $timers)
                }
            TimerScrollView(timers: $timers)
            Spacer()
        }
    }
}

struct TimerPopup : View {
    @Binding var popup: Bool
    @Binding var timers: [TimerStruct]
    @State var selection: [Int] = [0, 0, 0].map { $0 }
    @State var title = ""
    var ID: String = ""
    let calendar = Calendar.current
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                HStack {
                    Spacer()
                        .frame(width: 20)
                    TextField("Enter Timer Name", text: $title)
                        .frame(alignment: .leading)
                }
                Spacer()
                    .frame(height: 20)
            }
            ZStack {
                HStack {
                    Spacer()
                    Text("Hrs")
                        .font(.caption)
                        .rotationEffect(Angle(degrees: -90))
                        .opacity(0.5)
                        .frame(alignment: .center)
                    Spacer()
                        .frame(width: 100)
                    Spacer()
                    Text("Min")
                        .font(.caption)
                        .rotationEffect(Angle(degrees: -90))
                        .opacity(0.5)
                        .frame(alignment: .center)
                    Spacer()
                        .frame(width: 100)
                    Spacer()
                    Text("Sec")
                        .font(.caption)
                        .rotationEffect(Angle(degrees: -90))
                        .opacity(0.5)
                        .frame(alignment: .center)
                    Spacer()
                        .frame(width: 90)
                }
                HStack {
                    MultiPicker(data: [
                        ("Hours", Array(0...24).map { $0 }),
                        ("Minutes", Array(0..<60).map { $0 }),
                        ("Seconds", Array(0..<60).map { $0 })
                    ], selection: $selection)
                    Spacer()
                }
            }
//            ZStack {
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                            .frame(width: 37)
//                        Text("Hours")
//                            .frame(alignment: .center)
//                        Spacer()
//                        Text("Minutes")
//                            .frame(alignment: .center)
//                        Spacer()
//                        Text("Seconds")
//                            .frame(alignment: .center)
//                        Spacer()
//                            .frame(width: 35)
//                    }
//                    Spacer()
//                        .frame(height: 50)
//                    Spacer()
//                }
//                VStack {
//                    Spacer()
//                    HStack {
//                        Spacer()
//                        Text(":")
//                        Spacer()
//                            .frame(width: 125)
//                        Text(":")
//                        Spacer()
//                    }
//                    Spacer()
//                }
//                HStack {
//                    Spacer()
//                    MultiPicker(data: [
//                        ("Hours", Array(0...24).map { $0 }),
//                        ("Minutes", Array(0..<60).map { $0 }),
//                        ("Seconds", Array(0..<60).map { $0 })
//                    ], selection: $selection)
//                    Spacer()
//                        .frame(width: 18)
//                    Spacer()
//                }
//            }
            .frame(height: 250)
            Button {
                if title != "" {
                    var tmpDate = calendar.date(byAdding: .second, value: selection[2], to: Date.now)!
                    tmpDate = calendar.date(byAdding: .minute, value: selection[1], to: tmpDate)!
                    tmpDate = calendar.date(byAdding: .hour, value: selection[0], to: tmpDate)!
                    var tmp: TimerStruct = TimerStruct(totalTime: (selection[0]*60*60 + selection[1]*60 + selection[2]), startTime: Date.now, endTime: tmpDate, title: title, ID: ID, done: false)
                    timers.append(tmp)
                    tmp.makeNotif()
                    popup = false
                }
            } label: {
                Image(systemName: "plus.app")
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color(.systemGroupedBackground))
                            .frame(width: 200, height: 50)
                    )
            }
            Spacer()
        }
    }
}

struct MultiPicker: View  {
    //from https://stackoverflow.com/users/2890168/matteo-pacini
    //https://stackoverflow.com/questions/56567539/multi-component-picker-uipickerview-in-swiftui
    
    typealias Label = String
    typealias Entry = Int
    
    let data: [ (Label, [Entry]) ]
    @Binding var selection: [Entry]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(Array(0..<self.data.count), id:\.self) { column in
                    Picker(self.data[column].0, selection: self.$selection[column]) {
                        ForEach(Array(0..<self.data[column].1.count), id:\.self) { row in
                            Text((String(self.data[column].1[row])))
                                .tag(String(self.data[column].1[row]))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height)
                    .clipped()
                }
            }
        }
    }
}

struct TimerScrollView : View {
    @Binding var timers: [TimerStruct]
    var body: some View {
        VStack {
            ScrollView {
                ForEach(Array(0..<timers.count), id:\.self) {x in
                    if !timers[x].done {
                        Spacer()
                            .frame(height: 60)
                        TimerView(tstruct: $timers[x], timeRemain: timers[x].totalTime)
                            .frame(width: 350)
                            .swipeActions {
                                Button {
                                    timers[x].done = true
                                    timers[x].removeNotifs()
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                            .padding()
                    }
                }
            }
        }
        .frame(width: 350, height: 500)
    }
}

struct TimerView: View {
    @Binding var tstruct: TimerStruct
    @State var timeRemain: Int
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 20)
            VStack (alignment: .leading, spacing: 5) {
                Text(tstruct.title)
                    .font(.title3)
                HStack {
                    Text(tstruct.endTime, style: .time)
                        .font(.subheadline)
                        .foregroundStyle(timeRemain < 0 ? Color.red : Color.gray)
                    if timeRemain > 0 {
                        Text(String(timeRemain) + " seconds left")
                            .font(.subheadline)
                            .onReceive(timer) { _ in
                                timeRemain -= 1
                            }
                    } else {
                        Text("Timer done!")
                            .font(.subheadline)
                            .foregroundStyle(Color.red)
                    }
                }
            }
            Spacer()
            Button(action: {
                tstruct.done = true
                tstruct.removeNotifs()
            }, label: {
                Image(systemName: !tstruct.done ? "square" : "checkmark.square")
            })
            .toggleStyle(.button)
            Spacer()
                .frame(width: 20)
        }
        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .foregroundStyle(Color(.systemGroupedBackground))
//                .frame(width: 350, height: 100)
            CustomBackground(color: Color(.systemGroupedBackground), opac: 1.0)
        )
    }
}

struct TimerStruct : Codable {
    var totalTime: Int
    var startTime: Date
    var endTime: Date
    var title: String
    var ID: String
    var done: Bool
    var notifID: [String] = []
    mutating func makeNotif() {
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.subtitle = "Timer Done!"
        content.sound = UNNotificationSound.default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: endTime)
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(totalTime), repeats: false
        )
        
        let ID = UUID().uuidString
        let request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
        
        notifID.append(ID)
        UNUserNotificationCenter.current().add(request)
    }
    func removeNotifs() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notifID)
    }
}
