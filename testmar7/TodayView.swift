//
//  TodayView.swift
//  testmar7
//
//  Created by Riley Koo on 3/27/24.
//

import SwiftUI

//struct todayView: View {
//    @Binding var timers: [TimerStruct]
//    @Binding var reminders: [Reminder]
//    @Binding var activities: [Activity]
//    var body : some View {
extension ContentView {
    var todayView: some View {
        VStack {
            Text("Today")
                .font(.title2.bold())
            ScrollView {
                List {
                    if timers.contains(where: { t in
                        return isSameDay(date1: Date.now, date2: t.startTime) && !t.done
                    }) || reminders.contains(where: { r in
                        return isSameDay(date1: Date.now, date2: r.date) && !r.done
                    }) || activities.contains(where: { a in
                        return isSameDay(date1: Date.now, date2: a.start) && !a.done
                    }) {
//                        List {
                            let filteredTimers = timers.filter { t in
                                return isSameDay(date1: Date.now, date2: t.startTime) && !t.done
                            }
                            ForEach(Array(0..<filteredTimers.count), id:\.self) {x in
                                HStack {
                                    Text(filteredTimers[x].title)
                                        .font(.subheadline.bold())
                                    Text(filteredTimers[x].endTime, style: .time)
                                        .foregroundStyle(filteredTimers[x].endTime < Date.now ? Color.red : Color.gray)
                                }
                            }
                            let filteredReminders = reminders.filter { t in
                                return isSameDay(date1: Date.now, date2: t.date) && !t.done
                            }
                            ForEach(Array(0..<filteredReminders.count), id:\.self) {x in
                                HStack {
                                    Spacer()
                                        .frame(width: 5)
                                    Text(filteredReminders[x].title)
                                        .font(.subheadline.bold())
                                    Text(filteredReminders[x].ID)
                                    Spacer()
                                    Text(filteredReminders[x].date, style: .time)
                                        .foregroundStyle(filteredReminders[x].date < Date.now ? Color.red : Color.gray)
                                    Spacer()
                                        .frame(width: 5)
                                }
                            }
                            let filteredActivities = activities.filter { t in
                                return isSameDay(date1: Date.now, date2: t.start) && !t.done
                            }
                            ForEach(Array(0..<activities.count), id:\.self) {x in
                                HStack {
                                    Spacer()
                                        .frame(width: 5)
                                    Text(filteredActivities[x].title)
                                        .font(.subheadline.bold())
                                    Text(filteredActivities[x].ID)
                                    Spacer()
                                    Text(filteredActivities[x].start, style: .time)
                                        .foregroundStyle((filteredActivities[x].end > Date.now && filteredActivities[x].start < Date.now) ? Color.green : Color.gray)
                                    Text("-")
                                        .foregroundStyle((filteredActivities[x].end > Date.now && filteredActivities[x].start < Date.now) ? Color.green : Color.gray)
                                    Text(filteredActivities[x].end, style: .time)
                                        .foregroundStyle((filteredActivities[x].end > Date.now && filteredActivities[x].start < Date.now) ? Color.green : Color.gray)
                                    Spacer()
                                        .frame(width: 5)
                                }
                            }
//                        }
                    } else {
                        HStack {
                            Image(systemName: "moon.zzz")
                            Text("Nothing today!")
                                .font(.title3)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .frame(minWidth: 350, minHeight: 200, maxHeight: 200)
            }
        }
        .frame(minWidth: 350, minHeight: 200, maxHeight: 200)
        .modifier(
            CustomModif(color: Color(.systemGroupedBackground), opac: 0.7, w: 350, h: 200)
        )
    }
}
