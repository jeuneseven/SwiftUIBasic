//
//  BetterRestBasic.swift
//  SwiftUIBasic
//
//  Created by seven on 2025/9/9.
//

import SwiftUI
import CoreML // let user use machine learning to make predictions
import CreateMLComponents // create custom machine learning models with user's data

struct BetterRestBasic: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        Text(Date.now.formatted(date: .long, time: .shortened))
        // iOS will automatically format the date base on user's preferences, e.g day/month/year or month/day/year
        Text(Date.now, format: .dateTime.day().month().year().hour().minute())

        DatePicker("Please enter a date", selection: $wakeUp)
        // "" still occupy the place
        DatePicker("", selection: $wakeUp)

        DatePicker("Please enter a date", selection: $wakeUp)
            .labelsHidden()
        
        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .date)
        
        DatePicker("", selection: $wakeUp, displayedComponents: .hourAndMinute)
            .labelsHidden()
        
        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...) // swift can infer the data range
        
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: sleepAmount >= 10 ? 0.5 : 0.25)
            .frame(maxWidth: 200)
    }
    
    func trivialExample() {
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        // due to the data calculation and validation, Calendar.current.date will return a date?
        let date = Calendar.current.date(from: components) ?? .now

//        let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
//        let hour = components.hour ?? 0
//        let minute = components.minute ?? 0
    }
        
    func exampleDates() {
        // create a second Date instance set to one day in seconds from now
        let tomorrow = Date.now.addingTimeInterval(86400)

        // create a range from those two
        let range = Date.now...tomorrow
    }
}

#Preview {
    BetterRestBasic()
}
