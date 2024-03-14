//
//  To-dos.swift
//  testmar7
//
//  Created by Riley Koo on 3/12/24.
//

import SwiftUI

struct TodoListView: View {
    public var name: String
    @State var todos: [Todo]
    @State var toggles: [Bool]
    @State var notifIDs: [String] = []
    
    
    @State var ID: String
    
    @State private var text = ""
    @State private var date = Date.now
    @State private var showingPopover = false
    @State private var datePicker = false
    
    @State var CV: ContentView
    
    @State private var repeatInterval: Interval = Interval.None
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            Text(name)
                .font(.title.bold())
            Spacer()
            HStack {
                Spacer()
                    .frame(width: 15)
                TextField("Enter todo", text: $text)
                Button ("+") {
                    showingPopover = true
                }
                Spacer()
                    .frame(width: 15)
                .popover(isPresented: $showingPopover) {
                    HStack {
                        VStack (alignment: .center){
                            if datePicker {
                                DatePicker(
                                    "Start Date",
                                    selection: $date,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .datePickerStyle(.graphical)
                                .frame(width: 320, height: 320)
                                .labelsHidden()
                            }
                            Spacer()
                                .frame(height: 20)
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                Button(datePicker ? "Close" : "Select Time") {
                                    datePicker.toggle()
                                }
                                Spacer()
                                DateView(date: date)
                                    .opacity(0.5)
                                Spacer()
                                    .frame(width: 15)
                            }
                            Spacer()
                                .frame(height: 20)
                            HStack{
                                Spacer()
                                    .frame(width: 15)
                                Menu {
                                    Button("None") {
                                        repeatInterval = Interval.None
                                    }
                                    Button("Hourly") {
                                        repeatInterval = Interval.Hourly
                                    }
                                    Button("Daily") {
                                        repeatInterval = Interval.Daily
                                    }
                                    Button("Weekly") {
                                        repeatInterval = Interval.Weekly
                                    }
                                    Button("Monthly") {
                                        repeatInterval = Interval.Monthly
                                    }
                                } label: {
                                    Text("Type")
                                }
                                Spacer()
                                TypeView(interval: repeatInterval)
                                    .opacity(0.5)
                                Spacer()
                                    .frame(width: 15)
                            }
                            Spacer()
                                .frame(height: 20)
                            HStack{
                                Spacer()
                                    .frame(width: 15)
                                Button {
                                    let curTodo = Todo(ID: ID, title: text, date: date, status: false, interval: repeatInterval)
                                    toggles.append(true)
                                    todos.append(curTodo)
                                    makeNotif(repeatInterval: repeatInterval, todo: curTodo, date: date)
                                    text = ""
                                    date = Date.now
                                    showingPopover = false
                                    datePicker = false
                                    
                                    CV.todos = todos
                                    CV.toggles = toggles
                                    CV.notifIDs = notifIDs
                                } label: {
                                    Text("Add")
                                }
                                Spacer()
                                TextField("Enter todo", text: $text)
                                    .frame(alignment: .trailing)
                                    .multilineTextAlignment(.trailing)
                                Spacer()
                                    .frame(width: 15)
                            }
                            Spacer()
                                .frame(height: 20)
                            Button("Close") {
                                showingPopover = false
                                datePicker = false
                            }
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            ScrollView {
                ForEach (Array (0..<todos.count), id: \.self) { x in
                    if !todos[x].status {
                        HStack {
                            if todos[x].listId == ID {
                                TodoView(todo: todos[x])
                                Button(action: {
                                    todos[x].status = true
                                    toggles[x] = false
                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifIDs[x]])
                                    CV.completed += 1
                                }, label: {
                                    Image(systemName: toggles[x] ? "square" : "checkmark.square")
                                })
                                .toggleStyle(.button)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
    func makeNotif(repeatInterval: Interval, todo: Todo, date: Date){
        let text = todo.title
        let content = UNMutableNotificationContent()
        content.title = text
        content.subtitle = todo.listId
        content.sound = UNNotificationSound.default
        
        let triggerDate = date
        var trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate),
            repeats: false
        )
        if repeatInterval == Interval.Hourly {
            trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.minute], from: triggerDate),
                repeats: true
            )
        } else if repeatInterval == Interval.Daily {
            trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.hour, .minute], from: triggerDate),
                repeats: true
            )
        } else if repeatInterval == Interval.Weekly {
            trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.weekday, .hour, .minute], from: triggerDate),
                repeats: true
            )
        } else if repeatInterval == Interval.Monthly {
            trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.weekOfMonth, .weekday, .hour, .minute], from: triggerDate),
                repeats: true
            )
        }
        let ID = UUID().uuidString
        let request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
        notifIDs.append(ID)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    func setStuff(
        _todos: [Todo],
        _toggles: [Bool],
        _notifIDs: [String]
    ) -> Void {
        todos = _todos
        toggles = _toggles
        notifIDs = _notifIDs
    }
}

class Todo : Encodable, Decodable {
    var listId: String
    var title: String
    var date: Date
    var status: Bool
    var interval: Interval
    init(ID: String, title: String, date: Date, status: Bool, interval: Interval) {
        listId = ID
        self.title = title
        self.date = date
        self.status = status
        self.interval = interval
    }
    func setDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int
    ) -> Date {
        var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            components.hour = hour
            components.minute = minute
            components.timeZone = TimeZone.current
            let calendar = Calendar.current
            return calendar.date(from: components)!
    }
    func toggle() {
        status = false
    }
}

struct TodoView : View {
    @State var todo: Todo
    @State var check = false
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(todo.title)
                .font(.title3)
            HStack {
                Text(formatDate(todo.date))
                    .font(.subheadline)
                    .foregroundColor(todo.date < Date.now ? .red : .gray)
            }
        }
        .padding()
        .navigationTitle("Todo Details")
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DateView: View {
    @State var date: Date
    var body: some View {
        Text(date, format: .dateTime.month().day().hour().minute())
    }
}
struct TypeView: View {
    @State var interval: Interval
    var body: some View {
        switch interval {
        case Interval.Hourly:
            Text("Hourly")
        case Interval.Daily:
            Text("Daily")
        case Interval.Weekly:
            Text("Weekly")
        case Interval.None:
            Text("None")
        case Interval.Monthly:
            Text("Monthly")
        }
    }
}

struct MiniTodoView : View {
    @State var todo: Todo
    @State var check = false
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(todo.title)
                    .font(.callout)
                Text(todo.listId)
                    .font(.footnote)
                    .opacity(0.75)
            }
            HStack {
                Text(formatDate(todo.date))
                    .font(.footnote)
                    .foregroundColor(todo.date < Date.now ? .red : .gray)
            }
        }
        .padding()
        .navigationTitle("Todo Details")
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
