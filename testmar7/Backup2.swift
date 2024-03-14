////
////  ContentView.swift
////  testmar7
////
////  Created by Riley Koo on 3/7/24.
////
//
//
////Calendar View + assets from Kavsoft's Custom Date Picker Tutorial
//// https://www.youtube.com/watch?v=UZI2dvLoPr8
//
//import SwiftUI
//
//struct ContentView: View {
//    @SceneStorage("ContentView.todos") var todos: [Todo] = []
//    @SceneStorage("ContentView.toggles") var toggles: [Bool] = []
//    @SceneStorage("ContentView.notifIDs") var notifIDs: [String] = []
//    
//    
//    @SceneStorage("ContentView.pushNotifs") var pushNotifs: Bool = false
////
////    @SceneStorage("ContentView.todos") var todos: [[Todo]] = [[]]
////    @SceneStorage("ContentView.toggles") var toggles: [[Bool]] = [[]]
////    @SceneStorage("ContentView.notifIDs") var notifIDs: [[String]] = [[]]
//    
//    //@State var todoLists: [TodoListView] = []
//    @SceneStorage("ContentView.names") var names: [String] = []
//    
////    @SceneStorage("ContentView.todos") var todos: [Todo] = []
////    @SceneStorage("ContentView.toggles") var toggles: [Bool] = []
//    
//    @State var curName = ""
//    private let adaptiveColumn = [
//        GridItem(.adaptive(minimum: 150))
//    ]
//    
//    @State var currentDate: Date = Date.now
//    
//    //Month update on arrow click
//    @State var currentMonth = 0
//    
////    @SceneStorage("ContentView.tasks") var tasks: [TaskMetaData] = [TaskMetaData]()
//    
//    @State var tasksPopover = false
//    
//    @SceneStorage("ContentView.events") var events: [Event] = []
//    @SceneStorage("ContentView.eventsNames") var eventsNames: [String] = []
//    @State var curEventName = ""
//    @SceneStorage("ContentView.eventNotifIDs") var eventNotifIDs: [String] = []
//    
//    var body: some View {
//        if !pushNotifs {
//            Button("Request Permission") {
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                    if success {
//                        pushNotifs = true
//                    } else if let error {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//        }
//        else {
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
////                    .onTapGesture {
////                        tasks.removeAll()
////                        for todo in todos {
////                            TodoToTask(todo: todo)
////                        }
////                    }
//            }
//            .onAppear{
//                UIApplication.shared.applicationIconBadgeNumber = 0
//            }
//        }
//    }
//    
//    var eventsView: some View {
//        NavigationView {
//            VStack {
//                Spacer()
//                    .frame(height: 20)
//                Text("Events Lists")
//                    .font(.title.bold())
//                Spacer()
//                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
//                    ForEach(Array(0..<eventsNames.count), id:\.self) {x in
//                        HStack{
//                            NavigationLink{
//                                EventListView(events: events, CV: self, tag: eventsNames[x], eventsNotifIDs: eventNotifIDs)
//                            } label: {
//                                Text(eventsNames[x])
//                                    .font(.title3.bold())
//                            }
//                            Button{
//                                for x in 0..<events.count {
//                                    if events[x].ID == eventsNames[x]{
//                                        events.remove(at: x)
//                                    }
//                                }
//                                eventsNames.remove(at: x)
//                            } label: {
//                                Image(systemName: "trash")
//                            }
//                        }
//                    }
//                    VStack{
//                        TextField("Event group name", text:$curEventName)
//                            .frame(alignment: .center)
//                            .multilineTextAlignment(.center)
//                        Spacer()
//                            .frame(height: 20)
//                        Button{
//                            eventsNames.append(curEventName)
//                            curEventName = ""
//                        } label: {
//                            Text("Add")
//                                .frame(alignment: .center)
//                        }
//                    }
//                }
//                Spacer()
//            }
//        }
//    }
//    
//    var listsView: some View {
////        if !pushNotifs {
////            Button("Request Permission") {
////                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
////                    if success {
////                        pushNotifs = true
////                    } else if let error {
////                        print(error.localizedDescription)
////                    }
////                }
////            }
////        }
////        else {
//            VStack {
//                Spacer()
//                    .frame(height: 20)
//                Text("To-do Lists")
//                    .font(.title.bold())
//                Spacer()
//                    .frame(height: 15)
//                NavigationView {
//                    LazyVGrid(columns: adaptiveColumn, spacing: 20) {
//                        ForEach(Array(0..<names.count), id:\.self) {x in
//                            HStack{
//                                Spacer()
//                                    .frame(width: 10)
//                                NavigationLink{
////                                    TodoListView(name: names[x], todos: todos, toggles: toggles, ID: x)
//                                    TodoListView(name: names[x], todos: todos, toggles: toggles, notifIDs: notifIDs, ID: names[x], CV: self)
//                                } label: {
//                                    //Text(todoLists[x].name)
//                                    Text(names[x])
//                                        .font(.title3.bold())
//                                }
//                                Spacer()
//                                    .frame(width: 10)
//                                Button{
////                                    TodoListView(name: names[x], ID: names[x], CV: self).deleteEverything()
////                                    tasks.removeAll()
////                                    for todo in TodoListView(name: names[x], ID: names[x], CV: self).todos {
////                                        TodoToTask(todo: todo)
////                                    }
//                                    for y in 0..<todos.count {
//                                        if todos[y].listId == names[x] {
//                                            todos[y].status = true
//                                            toggles[y] = false
//                                        }
//                                    }
//                                    names.remove(at: x)
//                                } label: {
//                                    Image(systemName: "trash")
//                                }
//                                Spacer()
//                                    .frame(width: 10)
//                            }
//                            .padding()
//                        }
//                        VStack(alignment: .center){
//                            TextField("To-do list name", text: $curName)
//                                .frame(alignment: .center)
//                                .multilineTextAlignment(.center)
//                            Spacer()
//                                .frame(height: 20)
//                            Button {
//                                if curName != "" {
//                                    //todoLists.append(TodoListView(name: curName, ID: todoLists.count))
//                                    names.append(curName)
//                                    curName = ""
//                                }
//                            } label: {
//                                Text("Add")
//                                    .frame(alignment: .center)
//                            }
//                        }
//                    }
//                }
//            }
//        }
////    }
//    
//    var calendarBody: some View {
//        VStack(spacing: 35){
//            let days = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
//            HStack(spacing: 20){
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(extraDate()[0])
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                    Text(extraDate()[1])
//                        .font(.title.bold())
//                }
//                Spacer(minLength: 0)
//                Button {
//                    withAnimation{
//                        currentMonth -= 1
//                    }
//                } label: {
//                    Image(systemName: "chevron.left")
//                        .font(.title2)
//                }
//                Button {
//                    withAnimation{
//                        currentMonth += 1
//                    }
//                } label: {
//                    Image(systemName: "chevron.right")
//                        .font(.title2)
//                }
//            }
//            .padding(.horizontal)
//            
//            //Day View
//            HStack(spacing: 0){
//                ForEach(days, id:\.self) {day in
//                    Text(day)
//                        .font(.callout)
//                        .fontWeight(.semibold)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            
//            //Dates
//            let columns = Array(repeating: GridItem(.flexible()), count: 7)
//            LazyVGrid(columns: columns, spacing: 15) {
//                ForEach(extractDate()){ value in
//                    CardView(value: value)
//                        .background(
//                            Capsule()
//                                .fill(Color(.systemBlue))
//                                .padding(.horizontal, 8)
//                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
//                        )
//                        .onTapGesture {
//                            currentDate = value.date
//                        }
//                }
//            }
//            
//            Button{
//                tasksPopover = true
//            } label: {
//                Text("Tasks")
//                    .font(.title2)
//            }
//            .popover(isPresented: $tasksPopover){
//                VStack(spacing: 7) {
//                    
//                    HStack{
//                        Button{
//                            tasksPopover.toggle()
//                        } label: {
//                            Text("Close")
//                                .font(.title3.bold())
//                        }
//                        Spacer()
//                    }
//                    Spacer()
//                        .frame(maxHeight: 20)
//                    
//                    Text("Events")
//                        .font(.title3.bold())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    if let _ = events.first(where: { Event in
//                        return !Event.status &&
//                        dayIsBefore(date1: Event.startDate, date2: currentDate) &&
//                        dayIsAfter(date1: Event.endDate, date2: currentDate)
//                    }) {
//                        let tasks:[Event] = events.filter({ Event in
//                            return !Event.status &&
//                            dayIsBefore(date1: Event.startDate, date2: currentDate) &&
//                            dayIsAfter(date1: Event.endDate, date2: currentDate)
//                        }).sorted(by: { e1, e2 in
//                            return e1.startDate < e2.startDate
//                        })
//                        ForEach(Array(0..<tasks.count), id:\.self) { x in
//                            HStack( spacing: 10) {
//                                EventView(event: tasks[x])
//                                Spacer()
//                            }
//                            .padding(.horizontal)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .background(
//                                Color(.systemIndigo)
//                                    .opacity(0.35)
//                                    .cornerRadius(10)
//                            )
//                        }
//                    } else {
//                        Text("No Event Found")
//                    }
//                    Spacer()
//                        .frame(maxHeight: 20)
//                    
//                    
//                    Text("Tasks")
//                        .font(.title3.bold())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    if let _ = todos.first(where: { Todo in
//                        return !Todo.status && isSameDay(date1: Todo.date, date2: currentDate)
//                    }) {
//                        let tasks:[Todo] = todos.filter({ Todo in
//                            return !Todo.status && isSameDay(date1: Todo.date, date2: currentDate)
//                        })
//                        ForEach(Array(0..<tasks.count), id:\.self) { x in
//                            HStack( spacing: 10) {
//                                TodoView(todo: tasks[x])
//                                Spacer()
//                                Text(tasks[x].listId)
//                                    .font(.title3)
//                                Spacer()
//                                    .frame(width: 5)
////                                Text(tasks[x].title)
////                                    .font(.title2.bold())
////
////                                Text(tasks[x].time, style:.time)
//                                //Text(task.time.addingTimeInterval(CGFloat.random(in: 0...5000)), style: .time)
//                                
//                            }
//                            .padding(.horizontal)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .background(
//                                Color(.systemBlue)
//                                    .opacity(0.5)
//                                    .cornerRadius(10)
//                            )
//                        }
//                    } else {
//                        Text("No Task Found")
//                    }
//                    Spacer()
//                        .frame(maxHeight: .infinity)
//                }
//                .padding()
//            }
//        }
//        .onChange(of: currentMonth) { newValue in
//            //update month
//            currentDate = getCurrentMonth()
//        }
//    }
//    
//    func dayIsAfter(date1:Date, date2:Date) -> Bool {
//        let calendar = Calendar.current
//        return calendar.isDate(date1, inSameDayAs: date2) || date1 > date2
//    }
//    func dayIsBefore(date1:Date, date2:Date) -> Bool {
//        let calendar = Calendar.current
//        return calendar.isDate(date1, inSameDayAs: date2) || date1 < date2
//    }
//    
//    @ViewBuilder
//    func CardView(value: DateValue) -> some View{
//        VStack {
//            if value.day != -1 {
//                if let tasks = todos.first(where: { Todo in
//                    return !Todo.status && isSameDay(date1: Todo.date, date2: value.date)
//                }) {
//                    Text("\(value.day)")
//                        .font(.title3)
//                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
//                        .frame(maxWidth: .infinity)
//                    Spacer()
//                    
//                    Circle()
//                        .fill(Color(isSameDay(date1: tasks.date, date2: currentDate) ? .white : Color(.systemBlue)))
//                        .frame(width: 8, height: 8)
//                } else {
//                    Text("\(value.day)")
//                        .font(.title3)
//                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
//                        .frame(maxWidth: .infinity)
//                    Spacer()
//                }
//            }
//        }
//        .padding(.vertical, 7)
//        .frame(height: 50, alignment: .top)
//    }
//    
//    //checking dates
//    func isSameDay(date1:Date, date2:Date) -> Bool {
//        let calendar = Calendar.current
//        return calendar.isDate(date1, inSameDayAs: date2)
//    }
//    
//    //get year + month for display
//    func extraDate() -> [String] {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY MMMM"
//        
//        let date = formatter.string(from: currentDate)
//        return date.components(separatedBy: " ")
//    }
//    
//    func getCurrentMonth() -> Date {
//        let calendar = Calendar.current
//        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date())
//        else {
//            return Date()
//        }
//        return currentMonth
//    }
//    
//    func extractDate() -> [DateValue] {
//        let calendar = Calendar.current
//        let currentMonth = getCurrentMonth()
//        
//        var days = currentMonth.getAllDates().compactMap{ date -> DateValue in
//            let day = calendar.component(.day, from: date)
//            return DateValue(day: day, date: date)
//        }
//        
//        //offset
//        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
//        
//        for _ in 0..<firstWeekday - 1 {
//            days.insert(DateValue(day: -1, date: Date()), at: 0)
//        }
//        return days
//    }
////    func TodoToTask(todo: Todo){
////        let task = Task(title: todo.title, time: todo.date)
////        if var tmp = tasks.first(where: {specificTask in
////            specificTask.taskDate == todo.date
////        }) {
////            tmp.task.append(task)
////        } else {
////            tasks.append(TaskMetaData(task: [task], taskDate: todo.date))
////        }
////    }
//}
//
//struct TodoListView: View {
//    public var name: String
////    @SceneStorage("ContentView.todos") var todos: [Todo] = []
////    @SceneStorage("ContentView.toggles") var toggles: [Bool] = []
////    @SceneStorage("ContentView.notifIDs") private var notifIDs: [String] = []
////    @State var pushNotifs: Bool = false
//    @State var todos: [Todo]
//    @State var toggles: [Bool]
//    @State var notifIDs: [String] = []
//    
//    
//    @State var ID: String
//    
//    @State private var text = ""
//    @State private var date = Date.now
//    @State private var showingPopover = false
//    @State private var datePicker = false
////    @State private var repeatList = false
//    
//    @State var CV: ContentView
//    
//    @State private var repeatInterval: Interval = Interval.None
//    
//    var body: some View {
//        VStack {
//            Spacer()
//                .frame(height: 20)
//            Text(name)
//                .font(.title.bold())
//            Spacer()
//            HStack {
//                Spacer()
//                    .frame(width: 15)
//                TextField("Enter todo", text: $text)
//                Button ("+") {
//                    showingPopover = true
//                }
//                Spacer()
//                    .frame(width: 15)
//                .popover(isPresented: $showingPopover) {
//                    HStack {
//                        VStack (alignment: .center){
////                            @State var hwType = 0 // 0 = none, 1 = test, 2 = hw, 3 = proj
//                            if datePicker {
//                                DatePicker(
//                                    "Start Date",
//                                    selection: $date,
//                                    displayedComponents: [.date, .hourAndMinute]
//                                )
//                                .datePickerStyle(.graphical)
//                                .frame(width: 320, height: 320)
//                                .labelsHidden()
//                            }
//                            Spacer()
//                                .frame(height: 20)
//                            HStack {
//                                Spacer()
//                                    .frame(width: 15)
//                                Button(datePicker ? "Close" : "Select Time") {
//                                    datePicker.toggle()
//                                }
//                                Spacer()
//                                DateView(date: date)
//                                    .opacity(0.5)
//                                Spacer()
//                                    .frame(width: 15)
//                            }
//                            Spacer()
//                                .frame(height: 20)
//                            //.buttonStyle(CustomButton())
//                            HStack{
//                                Spacer()
//                                    .frame(width: 15)
//                                Menu {
//                                    Button("None") {
//                                        repeatInterval = Interval.None
//                                    }
//                                    Button("Hourly") {
//                                        repeatInterval = Interval.Hourly
////                                        repeatList = false
//                                    }
//                                    Button("Daily") {
//                                        repeatInterval = Interval.Daily
////                                        repeatList = false
//                                    }
//                                    Button("Weekly") {
//                                        repeatInterval = Interval.Weekly
////                                        repeatList = false
//                                    }
//                                    Button("Monthly") {
//                                        repeatInterval = Interval.Monthly
//                                    }
////                                    Button("One week reminders") {
////                                        hwType = 1
////                                    }
////                                    Button("Three day reminders") {
////                                        hwType = 2
////                                    }
////                                    Button("Five day reminders") {
////                                        hwType = 3
////                                    }
//                                } label: {
//                                    Text("Type")
//                                }
//                                Spacer()
//                                TypeView(interval: repeatInterval)
//                                    .opacity(0.5)
//                                Spacer()
//                                    .frame(width: 15)
//                            }
//                            Spacer()
//                                .frame(height: 20)
//                            //.buttonStyle(CustomButton())
//                            HStack{
//                                Spacer()
//                                    .frame(width: 15)
//                                Button {
//                                    let curTodo = Todo(ID: ID, title: text, date: date, status: false)
////                                    CV.TodoToTask(todo: curTodo)
//                                    toggles.append(true)
//                                    todos.append(curTodo)
////                                    switch hwType{
////                                    case 1:
////                                        createTest(date: date, text: text)
////                                    case 2:
////                                        createHw(date: date, text: text)
////                                    case 3:
////                                        createProject(date: date, text: text)
////                                    default:
//                                    makeNotif(repeatInterval: repeatInterval, todo: curTodo, date: date)
////                                    }
//                                    text = ""
//                                    date = Date.now
//                                    showingPopover = false
////                                    repeatList = false
//                                    datePicker = false
////                                    print(toggles)
//                                    
//                                    CV.todos = todos
//                                    CV.toggles = toggles
//                                    CV.notifIDs = notifIDs
//                                } label: {
//                                    Text("Add")
//                                }
//                                Spacer()
//                                TextField("Enter todo", text: $text)
//                                    .frame(alignment: .trailing)
//                                    .multilineTextAlignment(.trailing)
//                                Spacer()
//                                    .frame(width: 15)
//                            }
//                            Spacer()
//                                .frame(height: 20)
//                            //.buttonStyle(CustomButton())
//                            Button("Close") {
//                                showingPopover = false
////                                repeatList = false
//                                datePicker = false
//                            }
//                            //.buttonStyle(CustomButton())
//                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
//                    }
//                }
//            }
//            ScrollView {
//                ForEach (Array (0..<todos.count), id: \.self) { x in
////                    let x = todos.count - y - 1
//                    if !todos[x].status {
//                        HStack {
//                            if todos[x].listId == ID {
//                                TodoView(todo: todos[x])
//                                Button(action: {
//                                    todos[x].status = true
//                                    toggles[x] = false
////                                    todos.remove(at: x)
////                                    toggles.remove(at: x)
//                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifIDs[x]])
////                                    notifIDs.remove(at: x)
//                                }, label: {
//                                    Image(systemName: toggles[x] ? "square" : "checkmark.square")
//                                })
//                                .toggleStyle(.button)
//                            }
//                        }
//                    }
//                }
//            }
//            Spacer()
//        }
//        .padding()
//    }
//    func makeNotif(repeatInterval: Interval, todo: Todo, date: Date){
//        let text = todo.title
//        let content = UNMutableNotificationContent()
//        content.title = text
//        content.subtitle = todo.listId
//        content.sound = UNNotificationSound.default
//        
//        let triggerDate = date
//        var trigger = UNCalendarNotificationTrigger(
//            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate),
//            repeats: false
//        )
//        if repeatInterval == Interval.Hourly {
//            trigger = UNCalendarNotificationTrigger(
//                dateMatching: Calendar.current.dateComponents([.minute], from: triggerDate),
//                repeats: true
//            )
//        } else if repeatInterval == Interval.Daily {
//            trigger = UNCalendarNotificationTrigger(
//                dateMatching: Calendar.current.dateComponents([.hour, .minute], from: triggerDate),
//                repeats: true
//            )
//        } else if repeatInterval == Interval.Weekly {
//            trigger = UNCalendarNotificationTrigger(
//                dateMatching: Calendar.current.dateComponents([.weekday, .hour, .minute], from: triggerDate),
//                repeats: true
//            )
//        } else if repeatInterval == Interval.Monthly {
//            trigger = UNCalendarNotificationTrigger(
//                dateMatching: Calendar.current.dateComponents([.weekOfMonth, .weekday, .hour, .minute], from: triggerDate),
//                repeats: true
//            )
//        }
//        let ID = UUID().uuidString
//        let request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
//        notifIDs.append(ID)
//        
//        UNUserNotificationCenter.current().add(request)
//        
//    }
////    func createTest(
////        date: Date,
////        text: String
////    ){
////        makeNotif(repeatInterval: Interval.Daily, text: text, date: date)
////        for _ in 0 ..< 7 {
////            let tmp = Calendar.current.date(byAdding: .day, value: 1, to: date)!
////            makeNotif(repeatInterval: Interval.Daily, text: text, date: tmp)
////        }
////    }
////    func createHw(
////        date: Date,
////        text: String
////    ){
////        makeNotif(repeatInterval: Interval.Daily, text: text, date: date)
////        for _ in 0 ..< 3 {
////            let tmp = Calendar.current.date(byAdding: .day, value: 1, to: date)!
////            makeNotif(repeatInterval: Interval.Daily, text: text, date: tmp)
////        }
////    }
////    func createProject(
////        date: Date,
////        text: String
////    ){
////        makeNotif(repeatInterval: Interval.Daily, text: text, date: date)
////        for _ in 0 ..< 5 {
////            let tmp = Calendar.current.date(byAdding: .day, value: 1, to: date)!
////            makeNotif(repeatInterval: Interval.Daily, text: text, date: tmp)
////        }
////    }
//    func setStuff(
//        _todos: [Todo],
//        _toggles: [Bool],
//        _notifIDs: [String]
//    ) -> Void {
//        todos = _todos
//        toggles = _toggles
//        notifIDs = _notifIDs
//    }
//}
//
//class Todo : Encodable, Decodable {
//    var listId: String
//    var title: String
//    var date: Date
//    var status: Bool
//    init(ID: String, title: String, date: Date, status: Bool) {
//        listId = ID
//        self.title = title
//        self.date = date
//        self.status = status
//    }
//    func setDate(
//        year: Int,
//        month: Int,
//        day: Int,
//        hour: Int,
//        minute: Int
//    ) -> Date {
//        var components = DateComponents()
//            components.year = year
//            components.month = month
//            components.day = day
//            components.hour = hour
//            components.minute = minute
//            components.timeZone = TimeZone.current
//            let calendar = Calendar.current
//            return calendar.date(from: components)!
//    }
//    func toggle() {
//        status = false
//    }
//}
//
//struct TodoView : View {
//    @State var todo: Todo
//    @State var check = false
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text(todo.title)
//                .font(.title3)
//            HStack {
//                Text(formatDate(todo.date))
//                    .font(.subheadline)
//                    .foregroundColor(todo.date < Date.now ? .red : .gray)
////                Text(todo.status ? "Done" : "Pending")
//            }
//        }
//        .padding()
//        .navigationTitle("Todo Details")
//    }
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//}
//
//enum Interval {
//    case Hourly, Daily, Weekly, None, Monthly
//}
//struct CustomButton: ButtonStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        configuration.label
//            .padding()
//            .background(.blue)
//            .foregroundStyle(.white)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .scaleEffect(configuration.isPressed ? 1.2 : 1)
//            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
//    }
//}
//struct DateView: View {
//    @State var date: Date
//    var body: some View {
//        Text(date, format: .dateTime.month().day().hour().minute())
//    }
//}
//struct TypeView: View {
//    @State var interval: Interval
//    var body: some View {
//        switch interval {
//        case Interval.Hourly:
//            Text("Hourly")
//        case Interval.Daily:
//            Text("Daily")
//        case Interval.Weekly:
//            Text("Weekly")
//        case Interval.None:
//            Text("None")
//        case Interval.Monthly:
//            Text("Monthly")
//        }
//    }
//}
//extension Array: RawRepresentable where Element: Codable {
//    public init?(rawValue: String) {
//        guard let data = rawValue.data(using: .utf8),
//              let result = try? JSONDecoder().decode([Element].self, from: data)
//        else {
//            return nil
//        }
//        self = result
//    }
//
//    public var rawValue: String {
//        guard let data = try? JSONEncoder().encode(self),
//              let result = String(data: data, encoding: .utf8)
//        else {
//            return "[]"
//        }
//        return result
//    }
//}
//
//extension Date {
//    func getAllDates() -> [Date] {
//        let calendar = Calendar.current
//        
//        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
//        
//        let range = calendar.range(of: .day, in: .month, for: startDate)!
//        
//        return range.compactMap{day -> Date in
//            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
//        }
//    }
//}
//struct DateValue : Identifiable {
//    var id = UUID().uuidString
//    var day: Int
//    var date: Date
//}
//
//struct Event : Codable {
//    var status: Bool = false
//    var startDate: Date
//    var endDate: Date
//    var title: String
//    var ID: String
//    func happening(date: Date) -> Bool {
//        return date < endDate && date > startDate
//    }
//}
//
//struct EventView: View {
//    @State var event: Event
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text(event.title)
//                .font(.title3)
//            HStack {
//                Text(event.startDate, style: .time)
//                    .font(.subheadline)
//                    .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)
//                Text(" to ")
//                    .font(.subheadline)
//                    .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)
//                Text(event.endDate, style: .time)
//                    .font(.subheadline)
//                .foregroundColor((event.startDate < Date.now && event.endDate > Date.now ) ? .green : .gray)            }
//        }
//        .padding()
//        .navigationTitle("Event Details")
//    }
//}
//
//struct EventListView: View {
//    @State var events: [Event]
//    @State var CV: ContentView
//    @State var tag: String
//    @State private var curName: String = ""
//    @State private var curStart: Date = Date.now
//    @State private var curEnd: Date = Date.now
//    @State private var popup = false
//    @State private var start = false
//    @State private var end = false
//    @State var eventsNotifIDs: [String]
//    var body: some View {
//        VStack {
//            Spacer()
//                .frame(height: 20)
//            Text(tag)
//                .font(.title.bold())
//            Spacer()
//            HStack{
//                Spacer()
//                    .frame(width: 15)
//                TextField("Enter event", text: $curName)
//                    .frame(alignment: .leading)
//                    .multilineTextAlignment(.leading)
//                Spacer()
//                Button{
//                    popup = true
//                } label: {
//                    Text("+")
//                }
//                .popover(isPresented: $popup) {
//                    VStack{
//                        Spacer()
//                            .frame(height: 15)
//                        HStack{
//                            Spacer()
//                            TextField("Enter event", text: $curName)
//                                .frame(alignment: .center)
//                                .multilineTextAlignment(.center)
//                            Spacer()
//                        }
//                        Spacer()
//                            .frame(height: 15)
//                        HStack{
//                            Spacer()
//                                .frame(width: 15)
//                            Button{
//                                if end {
//                                    end.toggle()
//                                }
//                                start.toggle()
//                            } label: {
//                                Text(start ? "Close" : "Start Date")
//                            }
//                            Spacer()
//                            Text(curStart, style: .date)
//                                .opacity(0.5)
//                            Spacer()
//                                .frame(width: 15)
//                        }
//                        Spacer()
//                            .frame(height: 20)
//                        if start {
//                            DatePicker(
//                                "Start Date",
//                                selection: $curStart,
//                                displayedComponents: [.date, .hourAndMinute]
//                            )
//                            .datePickerStyle(.graphical)
//                            .frame(width: 320, height: 320)
//                            .labelsHidden()
//                            Spacer()
//                                .frame(height: 20)
//                        }
//                        HStack{
//                            Spacer()
//                                .frame(width: 15)
//                            Button{
//                                if start {
//                                    start.toggle()
//                                }
//                                end.toggle()
//                            } label: {
//                                Text(end ? "Close" : "End Date")
//                            }
//                            Spacer()
//                            Text(curEnd, style: .date)
//                                .opacity(0.5)
//                            Spacer()
//                                .frame(width: 15)
//                        }
//                        Spacer()
//                            .frame(height: 20)
//                        if end {
//                            DatePicker(
//                                "End Date",
//                                selection: $curEnd,
//                                displayedComponents: [.date, .hourAndMinute]
//                            )
//                            .datePickerStyle(.graphical)
//                            .frame(width: 320, height: 320)
//                            .labelsHidden()
//                            Spacer()
//                                .frame(height: 20)
//                        }
//                        Button {
//                            var eventAdd = Event(startDate: curStart, endDate: curEnd, title: curName, ID: tag)
//                            events.append(eventAdd)
//                            CV.events = events
//                            makeNotif(event: eventAdd)
//                            popup.toggle()
//                            curName = ""
//                            curStart = Date.now
//                            curEnd = Date.now
//                        } label: {
//                            Text("Add event")
//                        }
//                        Spacer()
//                            .frame(height: 20)
//                        Button {
//                            popup.toggle()
//                        } label: {
//                            Text("Close")
//                        }
//                    }
//                }
//                Spacer()
//                    .frame(width: 15)
//            }
//            ForEach(Array(0..<events.count), id:\.self) { x in
//                HStack{
//                    if events[x].ID == tag && !events[x].status {
//                        EventView(event: events[x])
//                        Text(tag)
//                            .font(.subheadline)
//                            .foregroundStyle(.gray)
//                        Button(action: {
//                            events[x].status = true
//                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [eventsNotifIDs[x]])
//                            eventsNotifIDs.remove(at: x)
//                        }, label: {
//                            Image(systemName: !events[x].status ? "square" : "checkmark.square")
//                        })
//                        .toggleStyle(.button)
//                    }
//                }
//            }
//            Spacer()
//        }
//    }
//    func makeNotif(event: Event){
//        let text = event.title
//        let content = UNMutableNotificationContent()
//        content.title = "In 10 Minutes: " + text
//        content.subtitle = event.ID
//        content.sound = UNNotificationSound.default
//        
//        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.startDate)
//        dateComponents.minute! -= 10
//        
//        var trigger = UNCalendarNotificationTrigger(
//            dateMatching: dateComponents,
//            repeats: false
//        )
//        let ID = UUID().uuidString
//        let request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
//        eventsNotifIDs.append(ID)
//        
//        UNUserNotificationCenter.current().add(request)
//        
//    }
//}
