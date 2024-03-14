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
//    @SceneStorage("ContentView.tasks") var tasks: [TaskMetaData] = [TaskMetaData]()
//    
//    @State var tasksPopover = false
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
//        }
//    }
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
//                Text("Todo Lists")
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
//                                    TodoListView(name: names[x], ID: names[x], CV: self)
//                                } label: {
//                                    //Text(todoLists[x].name)
//                                    Text(names[x])
//                                        .font(.title3.bold())
//                                }
//                                Spacer()
//                                    .frame(width: 10)
//                                Button{
//                                    TodoListView(name: names[x], ID: names[x], CV: self).deleteEverything()
//                                    tasks.removeAll()
//                                    for todo in TodoListView(name: names[x], ID: names[x], CV: self).todos {
//                                        TodoToTask(todo: todo)
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
//                            TextField("New list", text: $curName)
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
//                    Spacer()
//                    Text("Tasks")
//                        .font(.title3.bold())
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    if let task = tasks.first(where: { task in
//                        return isSameDay(date1: task.taskDate, date2: currentDate)
//                    }) {
//                        ForEach(task.task) { task in
//                            HStack( spacing: 10) {
//                                Text(task.title)
//                                    .font(.title2.bold())
//                                
//                                Text(task.time, style:.time)
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
//    @ViewBuilder
//    func CardView(value: DateValue) -> some View{
//        VStack {
//            if value.day != -1 {
//                if let task = tasks.first(where: { task in
//                    return isSameDay(date1: task.taskDate, date2: value.date)
//                }){
//                    Text("\(value.day)")
//                        .font(.title3)
//                        .foregroundColor(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : .primary)
//                        .frame(maxWidth: .infinity)
//                    Spacer()
//                    
//                    Circle()
//                        .fill(Color(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : Color(.systemBlue)))
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
//    func TodoToTask(todo: Todo){
//        let task = Task(title: todo.title, time: todo.date)
//        if var tmp = tasks.first(where: {specificTask in
//            specificTask.taskDate == todo.date
//        }) {
//            tmp.task.append(task)
//        } else {
//            tasks.append(TaskMetaData(task: [task], taskDate: todo.date))
//        }
//    }
//}
//
//struct TodoListView: View {
//    public var name: String
//    @SceneStorage("ContentView.todos") var todos: [Todo] = []
//    @SceneStorage("ContentView.toggles") var toggles: [Bool] = []
//    @SceneStorage("ContentView.notifIDs") private var notifIDs: [String] = []
////    @State var pushNotifs: Bool = false
////    @State var todos: [Todo]
////    @State var toggles: [Bool]
////    @State var notifIDs: [String] = []
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
//                            @State var repeatInterval: Interval = Interval.None
//                            @State var hwType = 0 // 0 = none, 1 = test, 2 = hw, 3 = proj
//                            if datePicker {
//                                DatePicker(
//                                    "Start Date",
//                                    selection: $date,
//                                    displayedComponents: [.date, .hourAndMinute]
//                                )
//                                .datePickerStyle(WheelDatePickerStyle())
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
//                                    Button("Hourly") {
//                                        repeatInterval = Interval.Hourly
////                                        repeatList = false
//                                    }
//                                    Button("Daily") {
//                                        repeatInterval = Interval.Daily
////                                        repeatList = false
//                                    }
//                                    Button("Weekly (Not implemented yet)") {
//                                        //repeatInterval = Interval.Weekly
////                                        repeatList = false
//                                    }
//                                    Button("One week reminders") {
//                                        hwType = 1
//                                    }
//                                    Button("Three day reminders") {
//                                        hwType = 2
//                                    }
//                                    Button("Five day reminders") {
//                                        hwType = 3
//                                    }
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
//                                    CV.TodoToTask(todo: curTodo)
//                                    toggles.append(true)
//                                    todos.append(curTodo)
//                                    switch hwType{
//                                    case 1:
//                                        createTest(date: date, text: text)
//                                    case 2:
//                                        createHw(date: date, text: text)
//                                    case 3:
//                                        createProject(date: date, text: text)
//                                    default:
//                                        makeNotif(repeatInterval: repeatInterval, text: text, date: date)
//                                    }
//                                    text = ""
//                                    date = Date.now
//                                    showingPopover = false
////                                    repeatList = false
//                                    datePicker = false
////                                    print(toggles)
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
////                                    todos[x].status = true
////                                    toggles[x] = false
//                                    todos.remove(at: x)
//                                    toggles.remove(at: x)
//                                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notifIDs[x]])
//                                    notifIDs.remove(at: x)
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
//    func makeNotif(repeatInterval: Interval, text: String, date: Date){
//        
//        let content = UNMutableNotificationContent()
//        content.title = text
//        //content.subtitle = ""
//        content.sound = UNNotificationSound.default
//        
//        // show this notification five seconds from now
//        let triggerDate = date
//        var trigger = UNCalendarNotificationTrigger(
//            dateMatching: Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute], from: triggerDate),
//            repeats: false
//        )
//        if repeatInterval == Interval.Hourly {
//            trigger = UNCalendarNotificationTrigger(
//                dateMatching: Calendar.current.dateComponents([.minute], from: triggerDate),
//                repeats: false
//            )
//        } else if repeatInterval == Interval.Daily {
//            trigger = UNCalendarNotificationTrigger(
//                dateMatching: Calendar.current.dateComponents([.hour, .minute], from: triggerDate),
//                repeats: false
//            )
//        }
//        // choose a random identifier
//        let ID = UUID().uuidString
//        let request = UNNotificationRequest(identifier: ID, content: content, trigger: trigger)
//        notifIDs.append(ID)
//        
//        // add our notification request
//        UNUserNotificationCenter.current().add(request)
//        
//    }
//    func createTest(
//        date: Date,
//        text: String
//    ){
//        makeNotif(repeatInterval: Interval.Daily, text: text, date: date)
//        for _ in 0 ..< 7 {
//            let tmp = Calendar.current.date(byAdding: .day, value: 1, to: date)!
//            makeNotif(repeatInterval: Interval.Daily, text: text, date: tmp)
//        }
//    }
//    func createHw(
//        date: Date,
//        text: String
//    ){
//        makeNotif(repeatInterval: Interval.Daily, text: text, date: date)
//        for _ in 0 ..< 3 {
//            let tmp = Calendar.current.date(byAdding: .day, value: 1, to: date)!
//            makeNotif(repeatInterval: Interval.Daily, text: text, date: tmp)
//        }
//    }
//    func createProject(
//        date: Date,
//        text: String
//    ){
//        makeNotif(repeatInterval: Interval.Daily, text: text, date: date)
//        for _ in 0 ..< 5 {
//            let tmp = Calendar.current.date(byAdding: .day, value: 1, to: date)!
//            makeNotif(repeatInterval: Interval.Daily, text: text, date: tmp)
//        }
//    }
//    func setStuff(
//        _todos: [Todo],
//        _toggles: [Bool],
//        _notifIDs: [String]
//    ) -> Void {
//        todos = _todos
//        toggles = _toggles
//        notifIDs = _notifIDs
//    }
//    func deleteEverything(){
//        for x in 0..<todos.count {
//            if todos[x].listId == ID {
//                todos.remove(at: x)
//                toggles.remove(at: x)
//                notifIDs.remove(at: x)
//            }
//        }
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
//                    .foregroundColor(.gray)
//                Text(todo.status ? "Done" : "Pending")
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
//    case Hourly, Daily, Weekly, None
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