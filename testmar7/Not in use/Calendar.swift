////
////  Calendar.swift
////  testmar7
////
////  Created by Riley Koo on 3/13/24.
////
//
//
//// Calendar View + some assets from Kavsoft's Custom Date Picker Tutorial
//// https://www.youtube.com/watch?v=UZI2dvLoPr8
//
//import SwiftUI
//
//extension ContentView {
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
//            HStack(spacing: 0){
//                ForEach(days, id:\.self) {day in
//                    Text(day)
//                        .font(.callout)
//                        .fontWeight(.semibold)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            
//            let columns = Array(repeating: GridItem(.flexible()), count: 7)
//            LazyVGrid(columns: columns, spacing: 15) {
//                ForEach(extractDate()){ value in
//                    Button {
//                        if isSameDay(date1: currentDate, date2: value.date) {
//                            dayViewPopover = true
//                        } else {
//                            currentDate = value.date
//                        }
//                    } label: {
//                        CardView(value: value)
//                            .background(
//                                Capsule()
//                                    .fill(Color(.systemBlue))
//                                    .padding(.horizontal, 8)
//                                    .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
//                            )
//                    }
//                    .sheet(isPresented: $dayViewPopover) {
//                        CalendarDayView(day: $currentDate, curDay: currentDate, totalEvents: events, events: events.filter({ e in
//                            return isSameDay(date1: e.startDate, date2: currentDate) &&
//                            isSameDay(date1: e.endDate, date2: currentDate)
//                        }))
//                    }
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
//    func isSameDay(date1:Date, date2:Date) -> Bool {
//        let calendar = Calendar.current
//        return calendar.isDate(date1, inSameDayAs: date2)
//    }
//    
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
//        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
//        
//        for _ in 0..<firstWeekday - 1 {
//            days.insert(DateValue(day: -1, date: Date()), at: 0)
//        }
//        return days
//    }
//}
//
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
//
//struct DateValue : Identifiable {
//    var id = UUID().uuidString
//    var day: Int
//    var date: Date
//}
//
//struct CalendarDayView: View {
//    @Binding var day: Date
//    @State var curDay: Date
//    var totalEvents: [Event]
//    @State var events: [Event]
//    @State private var offset = CGSize.zero
//    var body : some View {
//        VStack {
//            WeekView(date: $day)
//            ScrollView {
//                ZStack {
//                    ForEach(Array(0..<events.count), id:\.self) {x in
//                        HStack {
//                            Spacer()
//                                .frame(width: 50)
//                            Spacer()
//                                .frame(width: 85 * CGFloat(overlap(x: x)))
//                            CalendarDayViewEvent(event: $events[x])
//                            Spacer()
//                        }
//                        .frame(alignment: .leading)
//                    }
//                    VStack {
//                        ForEach(Array(0..<24), id: \.self) { x in
//                            Spacer()
//                                .frame(height: x == 0 ? 30 : 90)
//                            HStack {
//                                Spacer()
//                                    .frame(width: 10)
//                                Text(String(x%12 == 0 ? 12 : x%12) + ":00 " + (x<12 ? "am" : "pm"))
//                                    .font(.system(size: 10))
//                                    .opacity(0.5)
//                                VStack {
//                                    Divider()
//                                }
//                                Spacer()
//                                    .frame(width: 10)
//                            }
//                        }
//                        Spacer()
//                            .frame(height: 90)
//                        Divider()
//                        Spacer()
//                            .frame(height: 30)
//                    }
//                }
//            }
//            .onChange(of: day, { _, day in
//                withAnimation {
//                    curDay = day
//                    events = totalEvents.filter({ e in
//                        return isSameDay(date1: e.startDate, date2: day) && isSameDay(date1: e.endDate, date2: day)
//                    })
//                }
//                
//            })
//            .offset(x: offset.width * 1)
//            .opacity(2 - Double(abs(offset.width / 50)))
//            .gesture(
//                DragGesture()
//                    .onChanged { gesture in
//                        offset = gesture.translation
//                    }
//                    .onEnded { _ in
//                        if offset.width < -100 {
//                            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
//                        }
//                        if offset.width > 100 {
//                            day = Calendar.current.date(byAdding: .day, value: -1, to: day)!
//                        }
//                        offset = .zero
//                    }
//            )
//        }
//    }
//    func overlap(x: Int) -> Int {
//        var ret = 0
//        for y in 0..<x {
//            if events[x].startDate < events[y].startDate && events[x].endDate > events[y].endDate {
//                ret += 1
//            } else if events[x].startDate > events[y].startDate && events[x].endDate < events[y].endDate {
//                ret += 1
//            }
//        }
//        return ret
//    }
//    
//    func isSameDay(date1:Date, date2:Date) -> Bool {
//        let calendar = Calendar.current
//        return calendar.isDate(date1, inSameDayAs: date2)
//    }
//}
//
//struct CalendarDayViewEvent : View {
//    @Binding var event: Event
//    var body: some View {
//        VStack {
//            Spacer()
//                .frame(height: getTime() + 25.075)
//            eventDayCardView
//            Spacer()
//                .frame(height: 2460 - getTime() - getInBetween())
//        }
//    }
//    func getTime() -> CGFloat {
//        let min: Double = Double(Calendar.current.dateComponents([.minute], from: event.startDate).minute!) * 1.5
//        let hr: Double = Double(Calendar.current.dateComponents([.hour], from: event.startDate).hour!) * 68 * 1.5
//        return CGFloat(min + hr)
//    }
//    var eventDayCardView: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .frame(width: 75, height: getInBetween())
//                .opacity(0.5)
//                .foregroundStyle(Color.blue)
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(Color.blue, lineWidth: 5)
//                .frame(width: 75 - 5, height: getInBetween() - 5)
//            VStack {
//                Spacer()
//                    .frame(height: 20)
//                Text(event.title)
//                    .font(.footnote)
//                    .opacity(0.75)
//                    .foregroundStyle(Color.blue)
//                    .frame(width: 75, alignment: .top)
//                Text(event.ID)
//                    .font(.caption)
//                    .opacity(0.75)
//                    .foregroundStyle(Color.blue)
//                    .frame(width: 75, alignment: .top)
//                Spacer()
//            }
//        }
//    }
//    func getInBetween() -> CGFloat {
//        let calendar = Calendar.current
//        let min: Double = Double(calendar.dateComponents([.minute], from: event.endDate).minute! - calendar.dateComponents([.minute], from: event.startDate).minute!) * 1.5
//        let hr: Double = Double(calendar.dateComponents([.hour], from: event.endDate).hour! - calendar.dateComponents([.hour], from: event.startDate).hour!) * 68 * 1.5
//        return CGFloat(min + hr)
//    }
//}
//
//struct WeekView : View {
//    @Binding var date: Date
//    let calendar = Calendar.current
//    let days = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
//    var body: some View{
//        HStack {
//            Spacer()
//                .frame(width: 30)
//            ForEach(Array(0..<7), id:\.self) { x in
//                let tmp = calendar.dateComponents([.weekday], from: date).weekday! - 1
//                let num = calendar.dateComponents([.day], from: date).day!
//                Button {
//                    date = Calendar.current.date(byAdding: .day, value: -tmp+x, to: date)!
//                } label: {
//                    HStack {
//                        VStack {
//                            Text(days[x])
//                                .font(.caption2.bold())
//                                .foregroundStyle(tmp==x ? Color.white : Color.blue)
//                            Text(String(num - tmp + x))
//                                .font(.caption2.bold())
//                                .foregroundStyle(tmp==x ? Color.white : Color.blue)
//                        }
//                        .background {
//                            Circle()
//                                .foregroundStyle(Color.blue)
//                                .opacity(tmp==x ? 1.0 : 0.0)
//                                .frame(width: 40, height: 40)
//                        }
//                        if x == 6 {
//                            Spacer()
//                                .frame(width: 30)
//                        } else {
//                            Spacer()
//                        }
//                    }
//                }
//            }
//        }
//        .frame(width: 400, height: 100)
//    }
//}
