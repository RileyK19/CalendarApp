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
    @SceneStorage("ContentView.pushNotifs") var pushNotifs: Bool = false
    let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @State var currentDate: Date = Date.now
    @State var currentMonth = 0
    @State var tasksPopover = false
    
    @State var completedPopup = false
    @State var completedPopupEvent = false
    
    @State var settings = false
    
    @SceneStorage("ContentView.authenticate") var needAuth = false
    
    @State var dayViewPopover: Bool = false
    
    
    @SceneStorage("CV.Reminders") var reminders: [Reminder] = []
    @SceneStorage("CV.Activities") var activities: [Activity] = []
    @State var remindLists: [RemindList] = []
    @SceneStorage("CV.RlistNames") var RlistsNames: [String] = []
    @SceneStorage("CV.RlistColors") var colors: [String] = []
    let rlistCols = [
        GridItem(.adaptive(minimum: 150))
    ]
    @State private var rlistColor: Color = Color(hex: "443cc8")!
    @State private var rlistName = ""
    @State private var edit = false
    @State private var selected: [Int] = []
    @State private var selectedNotes: [Int] = []
    
    @State private var notesBool = false
    @State private var curOffset:CGSize = CGSize.zero
    
    @SceneStorage("NV.notes") var notes: [Note] = []
    @State private var curName = ""
    @State private var curColor: Color = Color.gray
    @State private var noteOffset = CGSize.zero
    
    @SceneStorage("TV.timers") var timers: [TimerStruct] = []
    
    @State private var timersOffset = CGSize.zero
    @State private var stopwatchBool = false
    
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
            //tabs
            RListsView
        }
    }
    
    var RListsView: some View {
        NavigationView {
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
                            .foregroundStyle(Color(hex: "443cc8")!)
                            .shadow(radius: 0.5, x: 0, y: 2)
                            .font(.callout.bold())
                            .padding(0)
                    }
                    Spacer()
                    if !edit {
                        Button {
                            edit = true
                        } label: {
                            Image(systemName: "pencil")
                                .foregroundStyle(Color(hex: "443cc8")!)
                                .shadow(radius: 0.5, x: 0, y: 2)
                                .font(.callout.bold())
                                .padding(0)
                        }
                    } else {
                        Button {
                            edit = false
                        } label : {
                            Text("Cancel")
                                .foregroundStyle(Color(hex: "443cc8")!)
                                .shadow(radius: 0.5, x: 0, y: 2)
                                .font(.callout.bold())
                        }
                        Button {
                            for x in selected {
                                for y in reminders.filter({ r in
                                    r.ID == remindLists[x].ID
                                }) {
                                    y.done = true
                                }
                                for y in activities.filter({ a in
                                    a.ID == remindLists[x].ID
                                }) {
                                    y.done = true
                                }
                                remindLists[x].deleteStuff()
                                RlistsNames.removeAll { list in
                                    list == remindLists[x].ID
                                }
                                remindLists.remove(at: x)
                            }
                            for x in selectedNotes {
                                notes[x].text = ""
                                notes.remove(at: x)
                            }
                            edit = false
                            selected = []
                            selectedNotes = []
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color(hex: "443cc8")!)
                                .shadow(radius: 0.5, x: 0, y: 2)
                                .font(.callout.bold())
                        }
                    }
                    Spacer()
                        .frame(width: 15)
                }
                .frame(height: 10)
                Spacer()
                    .frame(height: 10)
                Text("Remind Lists")
                    .font(.largeTitle.bold())
                Spacer()
                    .frame(height: 10)
                ScrollView {
//                    todayView(timers: $timers, reminders: $reminders, activities: $activities)
                    todayView
                    NavigationLink {
                        calendarBody
                    } label: {
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            Text("Calendar")
                            Spacer()
                            Image(systemName: "greaterthan")
                                .opacity(0.5)
                            Spacer()
                                .frame(width: 10)
                        }
                            .foregroundStyle(Color(.systemGroupedBackground))
//                            .frame(width: 350, height: 100)
//                            .background(
//                                CustomBackground(color: Color(hex: "04d1ff")!, opac: 1.0)
//                            )
                            .modifier(CustomModif(color: Color(hex: "04d1ff")!, opac: 1.0))
                    }
                    .onDisappear{
                        edit = false
                        selected = []
                    }
//                    .padding(.vertical, 10)
                    NavigationLink {
                        JournalView(CV: self)
                    } label: {
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            Text("Journal")
                            Spacer()
                            Image(systemName: "greaterthan")
                                .opacity(0.5)
                            Spacer()
                                .frame(width: 10)
                        }
                            .foregroundStyle(Color(.systemGroupedBackground))
//                            .frame(width: 350, height: 100)
//                            .background(
//                                CustomBackground(color: Color(hex: "2596be")!, opac: 0.8)
//                            )
                            .modifier(CustomModif(color: Color(hex: "2596be")!, opac: 0.8))
                    }
//                    .padding(.vertical, 10)
                    if !stopwatchBool {
                        NavigationLink {
                            TimerListView(timers: $timers)
                        } label: {
                            ZStack {
                                //CustomBackground(color: Color(hex: "3f54ff")!, opac: 0.9)
                                HStack {
                                    Spacer()
                                        .frame(width: 10)
                                    Text("Timers")
                                    Spacer()
                                    Image(systemName: "greaterthan")
                                        .opacity(0.5)
                                    Spacer()
                                        .frame(width: 10)
                                }
                                    .foregroundStyle(Color(.systemGroupedBackground))
                                    .frame(width: 350, height: 50)
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Circle()
                                            .foregroundStyle(Color.white)
                                            .frame(width: 5, height: 5)
                                        Spacer()
                                            .frame(width: 10)
                                        Circle()
                                            .stroke(Color.white, lineWidth: 0.5)
                                            .frame(width: 5, height: 4.5)
                                        Spacer()
                                    }
                                    Spacer()
                                        .frame(height: 5)
                                }
                            }
                            .modifier(CustomModif(color: Color(hex: "3f54ff")!, opac: 0.9))
                            .offset(x: timersOffset.width * 1)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        timersOffset = gesture.translation
                                    }
                                    .onEnded { _ in
                                        if timersOffset.width < -100 {
                                            stopwatchBool = true
                                        }
                                        timersOffset = .zero
                                    }
                            )
                        }
//                        .padding(.vertical, 10)
                    } else {
                        NavigationLink {
                            StopwatchView()
                        } label: {
                            ZStack {
                                //CustomBackground(color: Color(hex: "3f54ff")!, opac: 0.7)
                                HStack {
                                    Spacer()
                                        .frame(width: 10)
                                    Text("Stopwatch")
                                    Spacer()
                                    Image(systemName: "greaterthan")
                                        .opacity(0.5)
                                    Spacer()
                                        .frame(width: 10)
                                }
                                    .foregroundStyle(Color(.systemGroupedBackground))
                                    .frame(width: 350, height: 50)
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Circle()
                                            .stroke(Color.white, lineWidth: 0.5)
                                            .frame(width: 5, height: 4.5)
                                        Spacer()
                                            .frame(width: 10)
                                        Circle()
                                            .foregroundStyle(Color.white)
                                            .frame(width: 5, height: 5)
                                        Spacer()
                                    }
                                    Spacer()
                                        .frame(height: 5)
                                }
                            }
                            .modifier(CustomModif(color: Color(hex: "3f54ff")!, opac: 0.7))
                            .offset(x: timersOffset.width * 1)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        timersOffset = gesture.translation
                                    }
                                    .onEnded { _ in
                                        if timersOffset.width > 100 {
                                            stopwatchBool = false
                                        }
                                        timersOffset = .zero
                                    }
                            )
                        }
//                        .padding(.vertical, 10)
                    }
                    if !notesBool {
//                        ZStack {
//                            VStack {
//                                Spacer()
//                                    .frame(height: 20)
//                                HStack {
//                                    Spacer()
//                                    TextField("Remind List Name", text: $rlistName)
//                                        .foregroundStyle(Color.white)
//                                        .font(.subheadline)
//                                        .frame(height: 20, alignment: .center)
//                                    Spacer()
//                                }
//                                Spacer()
//                                Button {
//                                    if rlistName != "" {
//                                        RlistsNames.append(rlistName)
//                                        colors.append(rlistColor.toHex()!)
//                                        
//                                        edit = false
//                                        selected = []
//                                        
//                                        let tmp = RemindList(RemindersB: $reminders, ActivitiesB: $activities, ID: rlistName, color: rlistColor)
//                                        rlistColor = Color.gray
//                                        rlistName = ""
//                                        remindLists.append(tmp)
//                                    }
//                                } label: {
//                                    Image(systemName: "plus.app")
//                                        .resizable()
//                                        .foregroundStyle(Color(.systemGroupedBackground))
//                                        .frame(width: 15, height: 15)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 12)
//                                                .foregroundStyle(Color.white)
//                                                .opacity(0.25)
//                                                .brightness(0.1)
//                                                .frame(width: 40, height: 40)
//                                        )
//                                }
//                                Spacer()
//                                HStack {
//                                    Spacer()
//                                    ColorPicker("List Color", selection: $rlistColor)
//                                        .foregroundStyle(Color.white)
//                                        .font(.subheadline)
//                                        .frame(height: 20)
//                                    Spacer()
//                                }
//                                Spacer()
//                                    .frame(height: 20)
//                            }
//                            VStack {
//                                Spacer()
//                                HStack {
//                                    Spacer()
//                                    Circle()
//                                        .foregroundStyle(Color.white)
//                                        .frame(width: 5, height: 5)
//                                    Spacer()
//                                        .frame(width: 10)
//                                    Circle()
//                                        .stroke(Color.white, lineWidth: 0.5)
//                                        .frame(width: 5, height: 4.5)
//                                    Spacer()
//                                }
//                                Spacer()
//                                    .frame(height: 10)
//                            }
//                        }
//                        .frame(width: 325, height: 75)
//                        .padding(25)
//                        .background(
//                            CustomBackground(color: Color(hex: "443cc8")!, opac: 0.8)
//                        )
                        ZStack {
                            HStack {
                                Spacer()
                                    .frame(width: 7)
                                TextField("Remind List Name", text: $rlistName)
                                    .foregroundStyle(Color.white)
                                    .font(.subheadline)
                                    .frame(height: 20, alignment: .center)
                                Spacer()
                                Button {
                                    if rlistName != "" {
                                        RlistsNames.append(rlistName)
                                        colors.append(rlistColor.toHex()!)
                                        
                                        edit = false
                                        selected = []
                                        
                                        let tmp = RemindList(RemindersB: $reminders, ActivitiesB: $activities, ID: rlistName, color: rlistColor)
                                        rlistColor = Color.gray
                                        rlistName = ""
                                        remindLists.append(tmp)
                                    }
                                } label: {
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .foregroundStyle(Color(.systemGroupedBackground))
                                        .frame(width: 15, height: 15)
//                                        .background(
//                                            RoundedRectangle(cornerRadius: 12)
//                                                .foregroundStyle(Color.white)
//                                                .opacity(0.25)
//                                                .brightness(0.1)
//                                                .frame(width: 40, height: 40)
//                                        )
                                }
                                ColorPicker("List Color", selection: $rlistColor)
                                    .labelsHidden()
                                    .foregroundStyle(Color.white)
                                    .font(.subheadline)
                                    .frame(height: 20)
                                Spacer()
                                    .frame(width: 7)
                            }
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Circle()
                                        .foregroundStyle(Color.white)
                                        .frame(width: 5, height: 5)
                                    Spacer()
                                        .frame(width: 10)
                                    Circle()
                                        .stroke(Color.white, lineWidth: 0.5)
                                        .frame(width: 5, height: 4.5)
                                    Spacer()
                                }
                                Spacer()
                                    .frame(height: 10)
                            }
                        }
                        .modifier(CustomModif(color: Color(hex: "443cc8")!, opac: 0.8))
                        .offset(x: curOffset.width * 1)
                        .padding(.vertical, 10)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    curOffset = gesture.translation
                                }
                                .onEnded { _ in
                                    if curOffset.width < -100 {
                                        notesBool = true
                                    }
                                    curOffset = .zero
                                }
                        )
                    } else {
                        ZStack {
                            addNoteButton
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Circle()
                                        .stroke(Color.white, lineWidth: 0.5)
                                        .frame(width: 5, height: 4.5)
                                    Spacer()
                                        .frame(width: 10)
                                    Circle()
                                        .foregroundStyle(Color.white)
                                        .frame(width: 5, height: 5)
                                    Spacer()
                                }
                                Spacer()
                                    .frame(height: 5)
                            }
                            .frame(width: 325, height: 50)
                        }
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        noteOffset = gesture.translation
                                    }
                                    .onEnded { _ in
                                        if noteOffset.width > 100 {
                                            notesBool = false
                                        }
                                        noteOffset = .zero
                                    }
                            )
                    }
                    if !notesBool {
                        ForEach(Array(0..<remindLists.count), id:\.self) { x in
                            if !edit {
                                NavigationLink {
                                    remindLists[x]
                                } label: {
                                    remindLists[x].RemindListView
                                }
                            } else {
                                Button {
                                    selected.append(x)
                                } label: {
                                    remindLists[x].RemindListView
                                        .opacity(selected.contains(where: { i in
                                            return i == x
                                        }) ? 0.5 : 1)
                                }
                            }
                        }
                    } else {
                        ForEach(Array(0..<notes.count), id:\.self) {x in
                            VStack {
                                Spacer()
                                    .frame(height: 35)
                                if !edit {
                                    SingleNoteView(note: notes[x])
                                        .padding(10)
                                } else {
                                    Button {
                                        selectedNotes.append(x)
                                    } label: {
                                        SingleNoteView(note: notes[x]).noteDisplay
                                            .opacity(selectedNotes.contains(where: { i in
                                                return i == x
                                            }) ? 0.5 : 1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            for x in 0..<RlistsNames.count {
                if let _ = remindLists.first(where: { rlist in
                    rlist.ID == RlistsNames[x]
                }) {} else {
                    remindLists.append(RemindList(RemindersB: $reminders, ActivitiesB: $activities, ID: RlistsNames[x], color: Color(hex: colors[x])!, count: countStore(x: reminders.filter({ r in
                            return RlistsNames[x] == r.ID && !r.done
                        }).count + activities.filter({ a in
                            return RlistsNames[x] == a.ID && !a.done
                        }).count)
                    ))
                }
            }
        }
    }
    var addNoteButton: some View {
//        VStack {
//            Spacer()
//                .frame(height: 20)
//            HStack {
//                Spacer()
//                TextField("Note Page Name", text: $curName)
//                    .foregroundStyle(Color.white)
//                    .font(.subheadline)
//                    .frame(height: 20, alignment: .center)
//                Spacer()
//            }
//            Spacer()
//            Button {
//                if curName != "" {
//                    if curName != "" {
//                        notes.append(Note(ID: curName, text: "", color: curColor.toHex()!))
//                        curName = ""
//                        curColor = Color.gray
//                    }
//                }
//            } label: {
//                Image(systemName: "plus.app")
//                    .resizable()
//                    .foregroundStyle(Color(.systemGroupedBackground))
//                    .frame(width: 15, height: 15)
//                    .background(
//                        RoundedRectangle(cornerRadius: 12)
//                            .foregroundStyle(Color.white)
//                            .opacity(0.25)
//                            .brightness(0.1)
//                            .frame(width: 40, height: 40)
//                    )
//            }
//            Spacer()
//            HStack {
//                Spacer()
//                ColorPicker("Note Color", selection: $curColor)
//                    .foregroundStyle(Color.white)
//                    .font(.subheadline)
//                    .frame(height: 20)
//                Spacer()
//            }
//            Spacer()
//                .frame(height: 20)
//        }
        HStack {
            Spacer()
                .frame(width: 10)
            TextField("Note Page Name", text: $curName)
                .foregroundStyle(Color.white)
                .font(.subheadline)
                .frame(height: 20, alignment: .center)
            Spacer()
            Button {
                if curName != "" {
                    if curName != "" {
                        notes.append(Note(ID: curName, text: "", color: curColor.toHex()!))
                        curName = ""
                        curColor = Color.gray
                    }
                }
            } label: {
                Image(systemName: "plus.app")
                    .resizable()
                    .foregroundStyle(Color(.systemGroupedBackground))
                    .frame(width: 15, height: 15)
    //                .background(
    //                    RoundedRectangle(cornerRadius: 12)
    //                        .foregroundStyle(Color.white)
    //                        .opacity(0.25)
    //                        .brightness(0.1)
    //                        .frame(width: 40, height: 40)
    //                )
            }
                ColorPicker("Note Color", selection: $curColor)
                    .labelsHidden()
                    .foregroundStyle(Color.white)
                    .font(.subheadline)
                    .frame(height: 20)
                Spacer()
                    .frame(width: 10)
        }
//        .frame(width: 325, height: 75)
//        .padding(25)
//        .background(
//            CustomBackground(color: Color(hex: "7b435b")!, opac: 0.8)
//        )
        .modifier(CustomModif(color: Color(hex: "7b435b")!, opac: 0.6))
        .offset(x: noteOffset.width * 1)
        .padding(.vertical, 10)
    }
}

enum Interval : Codable {
    case Hourly, Daily, Weekly, None, Monthly
}

struct CustomBackground : View {
    var color: Color
    var opac: CGFloat
    var rad: CGFloat = 25
    var height: CGFloat = 100
    var width: CGFloat = 350
    var body: some View {
        rrectangle
    }
    var short : some View {
        ZStack {
            VStack {
                Divider()
                Spacer()
                    .frame(height: height/3)
                Divider()
            }
            RoundedRectangle(cornerRadius: rad/3)
                .frame(width: width, height: height/3)
                .foregroundStyle(color)
        }
    }
    var rrectangle : some View {
        RoundedRectangle(cornerRadius: rad)
            .shadow(radius: 2, x: 0, y: 2)
            .foregroundStyle(color)
            .opacity(opac)
            .frame(width: width, height: height)
    }
}

struct CustomModif : ViewModifier {
    var color: Color
    var opac: CGFloat
    var w: CGFloat = 350
    var h: CGFloat = 50
    func body(content: Content) -> some View {
        content
            .frame(width: w, height: h)
            .background(
                CustomBackground(color: color, opac: opac, rad: 17.5, height: h, width: w)
            )
            .padding(.vertical, 2.5)
    }
}
