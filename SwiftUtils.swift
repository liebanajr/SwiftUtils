//
//  SwiftUtils.swift
//  SwiftUtils
//
//  Created by Juan Rodríguez on 4/1/21.
//

import Foundation

//MARK: Dates management

 public struct TrueDate : Codable {
    public let currentDateTime : String?
    public let utcOffset : String?
    public let isDayLightSavingsTime : Bool?
    public let timeZoneName : String?
}

 public extension DateFormatter {
    static  func appStoreDateFormat() -> String{
        return "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    static  func trueTimeDateFormat() -> String{
        return "YYYY-MM-DDTHH:mmZ"
    }
}

 public extension Date {
    
    static  func fetchTrueDate(from url: String, _ completion: @escaping (_ date: Date) -> Void){
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                Log.error("Error fetching true date: \(error!.localizedDescription)")
                completion(Date())
                return
            }

            guard response.statusCode != 0 else {                    // check for http errors
                Log.error("statusCode should be 2xx, but is \(response.statusCode)")
                Log.error("response = \(response)")
                completion(Date())
                return
            }

            do {
                let decoder = JSONDecoder()
                let trueDate = try decoder.decode(TrueDate.self, from: data)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = DateFormatter.trueTimeDateFormat()
                if let currentTrueDateString = trueDate.currentDateTime, let timeZone = trueDate.timeZoneName{
                    dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
                    if let currentTrueDate =  dateFormatter.date(from: currentTrueDateString) {
                        Log.debug("True time is: \(currentTrueDate)")
                        completion(currentTrueDate)
                    }
                }
            } catch {
                Log.error("Error when decoding true time: \(error)")
                completion(Date())
            }
            completion(Date())
        }
        task.resume()
    }
    
    static  func create(withAppStoreDate string: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormatter.appStoreDateFormat()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        return dateFormatter.date(from: string)
    }

     func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

     func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
     func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
     func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
     func formatted(for component: Calendar.Component, isLong longFormat: Bool) -> String? {
        let dateFormatter = DateFormatter()
        switch component {
        case .second:
            dateFormatter.dateFormat = "HH"
            return "\(dateFormatter.string(from: self))h"
        case .day:
            dateFormatter.dateFormat = "dd"
            if longFormat {
                dateFormatter.dateFormat = "dd MMMM yyyy"
            }
        case .month:
            dateFormatter.dateFormat = "MMM"
            if longFormat {
                dateFormatter.dateFormat = "MMMM yyyy"
            }
        case .year:
            dateFormatter.dateFormat = "yyyy"
        default:
            return nil
        }
        return dateFormatter.string(from: self)
    }
    
     func appStoreFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormatter.appStoreDateFormat()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        
        return dateFormatter.string(from: self)
    }

     func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

     var isInThisYear:  Bool { isInSameYear(as: Date()) }
     var isInThisMonth: Bool { isInSameMonth(as: Date()) }
     var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

     var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
     var isInToday:     Bool { Calendar.current.isDateInToday(self) }
     var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

     var isInTheFuture: Bool { self > Date() }
     var isInThePast:   Bool { self < Date() }
    
     func startOfDay() -> Date {
        let gregorian = Calendar(identifier: Calendar.current.identifier)
        var todayComponents = gregorian.dateComponents(in: TimeZone.current, from: self)
        todayComponents.hour = 0
        todayComponents.minute = 0
        return gregorian.date(from: todayComponents)!
    }
    
     func endOfDay() -> Date {
        let gregorian = Calendar(identifier: Calendar.current.identifier)
        var todayComponents = gregorian.dateComponents(in: TimeZone.current, from: self)
        todayComponents.hour = 23
        todayComponents.minute = 59
        return gregorian.date(from: todayComponents)!
    }
}

//MARK: Number management

 public extension Int {
     func toFormattedString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self))!
    }
    
     func timeIntervalFormatted() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        
        let timeInterval = Double(self)
        return formatter.string(from: timeInterval) ?? "0s"
    }
}
public extension Int16 {
     func toFormattedString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self))!
    }
}
public extension Int32 {
     func toFormattedString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self))!
    }
}
public extension Int64 {
     func toFormattedString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self))!
    }
}

public extension Double {
     func toFormattedString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self))!
    }
    
     func timeIntervalFormatted() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 2
        
        return formatter.string(from: self) ?? "0s"
    }
}

public extension Float {
     func toFormattedString() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self))!
    }
}

//MARK: String management

public extension String {
     func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating  func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//MARK: App utilities


public struct AppInfo {
    public static var version : String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    public static var build : String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}
