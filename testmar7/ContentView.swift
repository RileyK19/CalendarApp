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
    private let adaptiveColumn = [
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
    
    var eventsView: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 20)
                HStack {
                    Spacer()
                        .frame(width: 20)
                    Text("Event Lists")
                        .font(.title.bold())
                        .frame(maxWidth: .infinity, alignment: .center)
                    Button {
                        completedPopupEvent = !completedPopupEvent
                    } label: {
                        HStack {
                            Image(systemName: "checkmark")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text(String(completed))
                                .fontWeight(.bold)
                                .frame(alignment: .trailing)
                        }
                    }
                    .popover(isPresented: $completedPopupEvent) {
                        VStack {
                            Spacer()
                                .frame(height: 10)
                            Text("Completed To-dos")
                                .font(.title2.bold())
                            ScrollView {
                                VStack {
                                    if let tmp = toggles.first(where: { status in
                                        return status
                                    }) {
                                        ForEach(Array(0..<todos.count), id:\.self) { x in
                                            if toggles[x] {
                                                HStack {
                                                    Spacer()
                                                        .frame(width: 10)
                                                    
                                                    MiniTodoView(todo: todos[x])
                                                        .frame(alignment: .center)
                                                    
                                                    Spacer()
                                                        .frame(width: 10)
                                                }
                                            }
                                        }
                                    } else {
                                        Text("No to-dos completed")
                                    }
                                }
                            }
                            .frame(maxHeight: 400)
                            Spacer()
                                .frame(height: 10)
                            Text("Completed Events")
                                .font(.title2.bold())
                            ScrollView {
                                VStack {
                                    if let tmp = events.first(where: { event in
                                        return !event.status
                                    }) {
                                        ForEach(Array(0..<events.count), id:\.self) { x in
                                            if !events[x].status {
                                                HStack {
                                                    Spacer()
                                                        .frame(width: 10)
                                                    MiniEventView(event: events[x])
                                                        .frame(alignment: .center)
                                                    
                                                    Spacer()
                                                        .frame(width: 10)
                                                }
                                            }
                                        }
                                    } else {
                                        Text("No events completed")
                                    }
                                }
                            }
                            .frame(maxHeight: 400)
                        }
                    }
                    Spacer()
                        .frame(width: 20)
                }
                Spacer()
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(Array(0..<eventsNames.count), id:\.self) {x in
                        HStack{
                            NavigationLink{
                                EventListView(events: events, CV: self, tag: eventsNames[x], eventsNotifIDs: eventNotifIDs)
                            } label: {
                                Text(eventsNames[x])
                                    .font(.title3.bold())
                            }
                            Button{
                                alertsEvents[x] = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .alert(isPresented: $alertsEvents[x]) {
                                Alert(
                                    title: Text("Delete " + eventsNames[x] + " ?"),
                                    message: Text("Deleted groups and associated events can not be recovered"),
                                    primaryButton: .default(
                                        Text("Try Again"),
                                        action: {
                                            alertsEvents[x] = false
                                        }
                                    ),
                                    secondaryButton: .destructive(
                                        Text("Delete"),
                                        action: {
                                            for x in 0..<events.count {
                                                if events[x].ID == eventsNames[x]{
                                                    events.remove(at: x)
                                                }
                                            }
                                            eventsNames.remove(at: x)
                                            alertsEvents[x] = false
                                        }
                                    )
                                )
                            }
                        }
                    }
                    VStack{
                        TextField("Event group name", text:$curEventName)
                            .frame(alignment: .center)
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 20)
                        Button{
                            eventsNames.append(curEventName)
                            curEventName = ""
                            alertsEvents.append(false)
                        } label: {
                            Text("Add")
                                .frame(alignment: .center)
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    var listsView: some View {
            NavigationView {
                VStack {
                    Spacer()
                        .frame(height: 20)
                    HStack {
                        Spacer()
                            .frame(width: 20)
                        Text("To-do Lists")
                            .font(.title.bold())
                            .frame(maxWidth: .infinity, alignment: .center)
                        Button {
                            completedPopup = !completedPopup
                        } label: {
                            HStack {
                                Image(systemName: "checkmark")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                Text(String(completed))
                                    .fontWeight(.bold)
                                    .frame(alignment: .trailing)
                            }
                        }
                        .popover(isPresented: $completedPopup) {
                            VStack {
                                Spacer()
                                    .frame(height: 10)
                                Text("Completed To-dos")
                                    .font(.title2.bold())
                                ScrollView {
                                    VStack {
                                        if let tmp = toggles.first(where: { status in
                                            return status
                                        }) {
                                            ForEach(Array(0..<todos.count), id:\.self) { x in
                                                if toggles[x] {
                                                    HStack {
                                                        Spacer()
                                                            .frame(width: 10)
                                                        
                                                        MiniTodoView(todo: todos[x])
                                                            .frame(alignment: .center)
                                                        Spacer()
                                                        Image("checkmark.square")
                                                        
                                                        Spacer()
                                                            .frame(width: 10)
                                                    }
                                                }
                                            }
                                        } else {
                                            Text("No to-dos completed")
                                        }
                                    }
                                }
                                .frame(maxHeight: 400)
                                Spacer()
                                    .frame(height: 10)
                                Text("Completed Events")
                                    .font(.title2.bold())
                                ScrollView {
                                    VStack {
                                        if let tmp = events.first(where: { event in
                                            return !event.status
                                        }) {
                                            ForEach(Array(0..<events.count), id:\.self) { x in
                                                if !events[x].status {
                                                    HStack {
                                                        Spacer()
                                                            .frame(width: 10)
                                                        
                                                        MiniEventView(event: events[x])
                                                            .frame(alignment: .center)
                                                        
                                                        Spacer()
                                                            .frame(width: 10)
                                                    }
                                                }
                                            }
                                        } else {
                                            Text("No events completed")
                                        }
                                    }
                                }
                                .frame(maxHeight: 400)
                            }
                        }
                        Spacer()
                            .frame(width: 20)
                    }
                    Spacer()
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    ForEach(Array(0..<names.count), id:\.self) {x in
                        HStack{
                            Spacer()
                                .frame(width: 10)
                            NavigationLink{
                                TodoListView(name: names[x], todos: todos, toggles: toggles, notifIDs: notifIDs, ID: names[x], CV: self)
                            } label: {
                                Text(names[x])
                                    .font(.title3.bold())
                            }
                            Spacer()
                                .frame(width: 10)
                            Button{
                                alertsTodos[x] = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .alert(isPresented: $alertsTodos[x]) {
                                Alert(
                                    title: Text("Delete " + names[x] + " ?"),
                                    message: Text("Deleted lists and associated to-dos can not be recovered"),
                                    primaryButton: .default(
                                        Text("Cancel"),
                                        action: {
                                            alertsTodos[x] = false
                                        }
                                    ),
                                    secondaryButton: .destructive(
                                        Text("Delete"),
                                        action: {
                                            for y in 0..<todos.count {
                                                if todos[y].listId == names[x] {
                                                    todos[y].status = true
                                                    toggles[y] = false
                                                }
                                            }
                                            names.remove(at: x)
                                            alertsTodos[x] = false
                                        }
                                    )
                                )
                            }
                            
                            Spacer()
                                .frame(width: 10)
                        }
                        .padding()
                    }
                    VStack(alignment: .center){
                        TextField("To-do list name", text: $curName)
                            .frame(alignment: .center)
                            .multilineTextAlignment(.center)
                        Spacer()
                            .frame(height: 20)
                        Button {
                            if curName != "" {
                                names.append(curName)
                                curName = ""
                                alertsTodos.append(false)
                            }
                        } label: {
                            Text("Add")
                                .frame(alignment: .center)
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    var calendarBody: some View {
        VStack(spacing: 35){
            let days = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
            HStack(spacing: 20){
                VStack(alignment: .leading, spacing: 10) {
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                Spacer(minLength: 0)
                Button {
                    withAnimation{
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                Button {
                    withAnimation{
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 0){
                ForEach(days, id:\.self) {day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(extractDate()){ value in
                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color(.systemBlue))
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            
            Button{
                tasksPopover = true
            } label: {
                Text("Tasks")
                    .font(.title2)
            }
            .popover(isPresented: $tasksPopover){
                VStack(spacing: 7) {
                    
                    HStack{
                        Button{
                            tasksPopover.toggle()
                        } label: {
                            Text("Close")
                                .font(.title3.bold())
                        }
                        Spacer()
                    }
                    Spacer()
                        .frame(maxHeight: 20)
                    
                    Text("Events")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let _ = events.first(where: { Event in
                        return !Event.status && 
                        dayIsBefore(date1: Event.startDate, date2: currentDate) &&
                        dayIsAfter(date1: Event.endDate, date2: currentDate)
                    }) {
                        let tasks:[Event] = events.filter({ Event in
                            return !Event.status &&
                            dayIsBefore(date1: Event.startDate, date2: currentDate) &&
                            dayIsAfter(date1: Event.endDate, date2: currentDate)
                        }).sorted(by: { e1, e2 in
                            return e1.startDate < e2.startDate
                        })
                        ForEach(Array(0..<tasks.count), id:\.self) { x in
                            HStack( spacing: 10) {
                                EventView(event: tasks[x])
                                Spacer()
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Color(.systemIndigo)
                                    .opacity(0.35)
                                    .cornerRadius(10)
                            )
                        }
                    } else {
                        Text("No Event Found")
                    }
                    Spacer()
                        .frame(maxHeight: 20)
                    
                    
                    Text("Tasks")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let _ = todos.first(where: { Todo in
                        return !Todo.status && isSameDay(date1: Todo.date, date2: currentDate)
                    }) {
                        let tasks:[Todo] = todos.filter({ Todo in
                            return !Todo.status && isSameDay(date1: Todo.date, date2: currentDate)
                        })
                        ForEach(Array(0..<tasks.count), id:\.self) { x in
                            HStack( spacing: 10) {
                                TodoView(todo: tasks[x])
                                Spacer()
                                Text(tasks[x].listId)
                                    .font(.title3)
                                Spacer()
                                    .frame(width: 5)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Color(.systemBlue)
                                    .opacity(0.5)
                                    .cornerRadius(10)
                            )
                        }
                    } else {
                        Text("No Task Found")
                    }
                    Spacer()
                        .frame(maxHeight: .infinity)
                }
                .padding()
            }
        }
        .onChange(of: currentMonth) { newValue in
            currentDate = getCurrentMonth()
        }
    }
    
    func dayIsAfter(date1:Date, date2:Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2) || date1 > date2
    }
    func dayIsBefore(date1:Date, date2:Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2) || date1 < date2
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View{
        VStack {
            if value.day != -1 {
                if let tasks = todos.first(where: { Todo in
                    return !Todo.status && isSameDay(date1: Todo.date, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3)
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    
                    Circle()
                        .fill(Color(isSameDay(date1: tasks.date, date2: currentDate) ? .white : Color(.systemBlue)))
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3)
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 7)
        .frame(height: 50, alignment: .top)
    }
    
    func isSameDay(date1:Date, date2:Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date())
        else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap{ date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
}
