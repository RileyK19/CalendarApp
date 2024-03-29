//
//  Stopwatch.swift
//  testmar7
//
//  Created by Riley Koo on 3/27/24.
//

import SwiftUI

struct StopwatchView : View {
    @ObservedObject var sw: StopWatch = StopWatch()
    @ObservedObject var lapSw: StopWatch = StopWatch()
    @State var laps: [String] = []
    @State var max: Int = -1
    @State var min: Int = -1
    var body : some View {
        VStack {
            Spacer()
                .frame(height: 50)
            Text("Stopwatch")
                .font(.title.bold())
            Spacer()
                .frame(height: 50)
            Text(sw.timeElapsedFormatted)
                .font(.title.bold())
                .foregroundStyle(Color(.systemGroupedBackground))
                .frame(width: 350, height: 100)
                .background(
                    CustomBackground(color: Color(hex: "3f54ff")!, opac: 0.8)
                )
            Spacer()
                .frame(height: 80)
            HStack {
                if sw.mode == .timing {
                    Button {
                        laps.append(lapSw.timeElapsedFormatted)
                        max == -1 ? max = laps.count-1 : (max = laps[max] < lapSw.timeElapsedFormatted ? laps.count-1 : max)
                        min == -1 ? min = laps.count-1 : (min = laps[min] > lapSw.timeElapsedFormatted ? laps.count-1 : min)
                        lapSw.stop()
                        lapSw.start()
                    } label: {
                        Text("Lap")
                            .foregroundStyle(Color.white)
                            .background(
                                Circle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color.yellow)
                                    .opacity(0.7)
                            )
                    }
                    .frame(width: 100, height: 100)
                } else {
                    Button {
                        sw.stop()
                        lapSw.stop()
                        laps = []
                        max = -1
                        min = -1
                    } label: {
                        Text("Stop")
                            .foregroundStyle(Color.white)
                            .background(
                                Circle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color.red)
                                    .opacity(0.7)
                            )
                    }
                    .frame(width: 100, height: 100)
                }
                Spacer()
                    .frame(width: 100)
                if sw.mode == .timing {
                    Button {
                        sw.pause()
                        lapSw.pause()
                    } label: {
                        Text("Pause")
                            .foregroundStyle(Color.white)
                            .background(
                                Circle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color.yellow)
                                    .opacity(0.7)
                            )
                    }
                    .frame(width: 100, height: 100)
                } else {
                    Button {
                        sw.start()
                        lapSw.start()
                    } label: {
                        Text("Start")
                            .foregroundStyle(Color.white)
                            .background(
                                Circle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color.green)
                                    .opacity(0.7)
                            )
                    }
                    .frame(width: 100, height: 100)
                }
            }
            Spacer()
                .frame(height: 100)
            ScrollView {
                ForEach(Array(0..<laps.count), id:\.self) {x in
                    HStack {
                        Spacer()
                        Text(laps[laps.count-1-x])
                            .font(.title.bold())
                            .opacity(0.8)
                            .foregroundStyle(laps.count-1-x == max ? Color.red : (laps.count-1-x == min ? Color.green : Color.gray))
                        Spacer()
                    }
                }
            }
            Spacer()
        }
    }
}

class StopWatch: ObservableObject {
    //taken from @apple_pie on https://www.hackingwithswift.com
    //https://www.hackingwithswift.com/forums/swiftui/how-do-i-create-a-stopwatch-with-lap-times-in-swiftui/6998

    @Published var timeElapsedFormatted = "00:00.00"
    @Published var mode: stopWatchMode = .stopped

    var secondsElapsed = 0.0
    var completedSecondsElapsed = 0.0
    var timer = Timer()

    func start() {
        self.mode = .timing
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
        self.secondsElapsed += 0.01
        self.formatTime()
        }
    }

    func stop() {
        timer.invalidate()
        self.mode = .stopped
        self.completedSecondsElapsed = self.secondsElapsed
        self.secondsElapsed = 0.0
        self.timeElapsedFormatted = "00:00.00"
    }

    func pause() {
        timer.invalidate()
        self.mode = .paused
    }

    func formatTime() {
        let minutes: Int32 = Int32(self.secondsElapsed/60)
        let minutesString = (minutes < 10) ? "0\(minutes)" : "\(minutes)"
        let seconds: Int32 = Int32(self.secondsElapsed) - (minutes * 60)
        let secondsString = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        let milliseconds: Int32 = Int32(self.secondsElapsed.truncatingRemainder(dividingBy: 1) * 100)
        let millisecondsString = (milliseconds < 10) ? "0\(milliseconds)" : "\(milliseconds)"
        self.timeElapsedFormatted = minutesString + ":" + secondsString + "." + millisecondsString
    }
}

enum stopWatchMode {
    //taken from @apple_pie on https://www.hackingwithswift.com
    //https://www.hackingwithswift.com/forums/swiftui/how-do-i-create-a-stopwatch-with-lap-times-in-swiftui/6998
    case timing
    case stopped
    case paused
}
