//
//  Calendar.swift
//  testmar7
//
//  Created by Riley Koo on 3/13/24.
//


// Calendar View + some assets from Kavsoft's Custom Date Picker Tutorial
// https://www.youtube.com/watch?v=UZI2dvLoPr8

import SwiftUI

enum Interval : Codable {
    case Hourly, Daily, Weekly, None, Monthly
}
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap{day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

struct DateValue : Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
