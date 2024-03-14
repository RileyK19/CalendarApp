//
//  Journal.swift
//  testmar7
//
//  Created by Riley Koo on 3/13/24.
//

import SwiftUI
import LocalAuthentication

struct JournalView: View {
    @SceneStorage("JournalView.journalTexts") var journals: [JournalStruct] = []
    @State private var text: String = ""
    @State private var blue: Bool = true
    @State var prevMessage: Date = Calendar.current.date(byAdding: .minute, value: -61, to: Date.now)!
    @State var curDate: Date = Date.now
    @State var cardlist: CardList = CardList(today: Date.now)
    
    private let days = ["Sat", "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri"]
    
    @State var unlocked = false
    @State var CV: ContentView
    
    var body: some View {
        ZStack {
            JournalViewBody
                .frame(maxWidth: 500)
                .blur(radius: (CV.needAuth != unlocked) ? 20 : 0)
            if CV.needAuth != unlocked {
                Button {
                    authenticate()
                } label: {
                    Text("FaceID to Unlock Journals")
                        .font(.title.bold())
                }
            }
        }
    }
    var JournalViewBody: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            if isToday(date: curDate, date2: Date.now) {
                HStack {
                    Spacer()
                    cardlist
                    Spacer()
                }
            } else {
                VStack {
                    Text(String(Calendar.current.component(.day, from: curDate)))
                        .font(.title.bold())
                        .foregroundStyle(.blue)
                        .opacity(60)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white)
                                .frame(width: 65, height: 40)
                        )
                    Spacer()
                        .frame(height: 10)
                    Text(days[(Calendar.current.component(.weekday, from: curDate))%7])
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .frame(alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.blue)
                        .opacity(60)
                        .frame(width: 85, height: 85)
                )
                .padding(5)
            }
            Spacer()
                .frame(height: 15)
            HStack {
                Spacer()
                    .frame(width: 15)
                Button {
                    curDate = Calendar.current.date(byAdding: .day, value: -1, to: curDate)!
                    curDate = transformDate(date1: curDate)
                    cardlist = CardList(today: curDate)
                } label : {
                    Image(systemName: "chevron.left.2")
                        .font(.callout.bold())
                }
                Spacer()
                    .frame(maxWidth: 150)
                Button {
                    curDate = Date.now
                    cardlist = CardList(today: curDate)
                } label : {
                    Text("Today")
                        .font(.callout.bold())
                }
                Spacer()
                    .frame(maxWidth: 150)
                Button {
                    curDate = Calendar.current.date(byAdding: .day, value: 1, to: curDate)!
                    curDate = transformDate(date1: curDate)
                    cardlist = CardList(today: curDate)
                } label : {
                    Image(systemName: "chevron.right.2")
                        .font(.callout.bold())
                }
                Spacer()
                    .frame(width: 15)
            }
            Spacer()
            ScrollView {
                ScrollViewReader { proxy in
                    Spacer()
                        .frame(width: 500)
                    ForEach(Array(0..<journals.count), id:\.self) {x in
                        if isToday(date: dateString(text: journals[x].date), date2: curDate) {
                            Bubble(text: journals[x].text, blue: journals[x].blue, prev: prevMessage)
                                .contextMenu(menuItems: {
                                    Group {
                                        Button {
                                            journals.remove(at: x)
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                                })
                        }
                    }
                    .onChange(of: journals.count) { oldValue, newValue in
                        withAnimation {
                            proxy.scrollTo(journals.count-1)
                        }
                    }
                }
            }
            .frame(minWidth: 500, maxHeight: 600)
            if isToday(date: curDate, date2: Date.now) {
                HStack {
                    Spacer()
                        .frame(width: 10)
                    TextField("Write...", text: $text, axis: .vertical)
                        .textFieldStyle(WhiteBorder())
                        .frame(maxWidth: 325, minHeight: 30)
                        .lineLimit(10)
                        .frame(alignment: .leading)
                    Button {
                        if text != "" {
                            journals.append(JournalStruct(text: text, date: dateString(date: Date.now), blue: blue))
                            text = ""
                            blue.toggle()
                            prevMessage = Date.now
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 50 , height: 50)
                            Image(systemName: "arrowshape.up")
                                .foregroundStyle(.white)
                                .font(.system(size: 30))
                        }
                    }
                    .frame(alignment: .trailing)
                }
            }
        }
    }
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Please authenticate to unlock journal"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    // authenticated successfully
                    unlocked = true
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
}

struct CalendarDayCard: View {
    @State var date: Date
    let calendar = Calendar.current
    private let days = ["Sat", "Sun", "Mon", "Tues", "Wed", "Thurs", "Fri"]
    @State var today: Bool = false
    var body: some View {
        if today {
            VStack {
                Text(String(calendar.component(.day, from: date)))
                    .font(.title.bold())
                    .foregroundStyle(.blue)
                    .opacity(60)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                            .frame(width: 65, height: 40)
                    )
                Spacer()
                    .frame(height: 10)
                Text(days[(calendar.component(.weekday, from: date))])
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            .frame(alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.blue)
                    .opacity(60)
                    .frame(width: 85, height: 85)
            )
        } else {
            VStack {
                Text(String(calendar.component(.day, from: date)))
                    .font(.title2.bold())
                    .foregroundStyle(.gray)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 55, height: 30)
                    )
                Text(days[(calendar.component(.weekday, from: date))%7])
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            .frame(alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray)
                    .frame(width: 65, height: 65)
            )
        }
    }
}

struct CardList: View {
    @State var today: Date
    private let calendar = Calendar.current
    var body: some View {
        HStack {
            Spacer()
            CalendarDayCard(date: calendar.date(byAdding: .day, value: -2, to: today)!)
                .padding(15)
            CalendarDayCard(date: calendar.date(byAdding: .day, value: -1, to: today)!)
                .padding(15)
            CalendarDayCard(date: today, today: true)
                .padding(15)
            CalendarDayCard(date: calendar.date(byAdding: .day, value: 1, to: today)!)
                .padding(15)
            CalendarDayCard(date: calendar.date(byAdding: .day, value: 2, to: today)!)
                .padding(15)
            Spacer()
        }
        .frame(alignment: .center)
    }
}

struct Bubble: View {
    @State var text: String
    @State var blue: Bool
    @State var prev: Date
    var body: some View {
        VStack {
            if dateDiff(date1: prev, date2: Date.now) > 60 {
                Text(Date.now, style: .time)
                    .font(.caption2)
                    .opacity(0.5)
            }
            if blue {
                HStack {
                    Spacer()
                        .frame(maxWidth: 100)
                    Text(text)
                        .padding(10)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .lineLimit(30)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 250, alignment: .trailing)
                }
            } else {
                HStack {
                    Text(text)
                        .padding(10)
                        .foregroundColor(Color.black)
                        .background(Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                        .cornerRadius(12)
                        .lineLimit(30)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 250, alignment: .leading)
                    Spacer()
                        .frame(maxWidth: 100)
                }
            }
        }
    }
    func dateDiff(date1: Date, date2: Date) -> Int {
        let diffs = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date1, to: date2)
        var ret = diffs.minute ?? 0
        ret += (diffs.hour ?? 0) * 60
        ret += (diffs.day ?? 0) * 1000
        ret += (diffs.month ?? 0) * 1000
        ret += (diffs.year ?? 0) * 1000
        return ret
    }
}
                
struct WhiteBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.gray, lineWidth:2)
                    .opacity(0.5)
            )
    }
}

struct JournalStruct : Codable {
    var text: String
    var date: String
    var blue: Bool
}

func dateString(text: String) -> Date {
    var tmp = DateComponents()
    let textSeperate = text.components(separatedBy: "-")
    tmp.year = Int(textSeperate[0]) ?? 0
    tmp.month = Int(textSeperate[1]) ?? 0
    tmp.day = Int(textSeperate[2]) ?? 0
    return Calendar.current.date(from: tmp) ?? Date()
}

func dateString(date: Date) -> String {
    let tmp = Calendar.current.dateComponents([.year, .month, .day], from: date)
    var ret = String(tmp.year ?? 0) + "-"
    ret += String(tmp.month ?? 0) + "-"
    ret += String(tmp.day ?? 0)
    return ret
}

func isToday(date: Date, date2: Date) -> Bool {
    let tmp = Calendar.current.dateComponents([.year, .month, .day], from: date2)
    let tmp2 = Calendar.current.dateComponents([.year, .month, .day], from: date)
    return tmp == tmp2
}

func transformDate(date1: Date) -> Date {
    let calendar = Calendar.current
    var comp = calendar.dateComponents([.year, .month, .day], from: date1)
    if comp.isValidDate(in: calendar) {
        return calendar.date(from: comp)!
    }
    if calendar.dateComponents([.year, .month], from: date1).isValidDate(in: calendar) {
        if comp.day! > 28 {
            comp.month! += 1
            var x = 0
            while !comp.isValidDate(in: calendar) {
                comp.day! -= 1
                x += 1
            }
            comp.day! = x
        } else {
            comp.month! -= 1
            comp.day = 31
            while !comp.isValidDate(in: calendar) {
                comp.day! -= 1
            }
        }
    }
    if comp.month! > 12 {
        comp.month! = comp.month! - 12
    } else if comp.month! < 1 {
        comp.month! = 12 + (comp.month!)
    }
    return calendar.date(from: comp)!
}
