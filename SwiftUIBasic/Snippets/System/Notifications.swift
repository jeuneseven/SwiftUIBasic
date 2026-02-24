//
//  Notifications.swift
//  SwiftUIBasic
//
//  Local notifications using UserNotifications framework
//

import SwiftUI
import UserNotifications

// MARK: - Basic Local Notification

struct BasicNotificationExample: View {
    @State private var permissionStatus = "Unknown"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Local Notifications")
                .font(.headline)
            
            Image(systemName: "bell.badge")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text("Permission: \(permissionStatus)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Button("Request Permission") {
                requestPermission()
            }
            .buttonStyle(.bordered)
            
            Button("Schedule Notification (5 sec)") {
                scheduleNotification()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Notification will appear in 5 seconds")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .onAppear {
            checkPermissionStatus()
        }
    }
    
    private func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    permissionStatus = "Granted"
                } else if let error {
                    permissionStatus = "Error: \(error.localizedDescription)"
                } else {
                    permissionStatus = "Denied"
                }
            }
        }
    }
    
    private func checkPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    permissionStatus = "Authorized"
                case .denied:
                    permissionStatus = "Denied"
                case .notDetermined:
                    permissionStatus = "Not Determined"
                case .provisional:
                    permissionStatus = "Provisional"
                case .ephemeral:
                    permissionStatus = "Ephemeral"
                @unknown default:
                    permissionStatus = "Unknown"
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hello!"
        content.body = "This is a local notification from SwiftUI."
        content.sound = .default
        
        // Trigger after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Notification with Actions

struct NotificationActionsExample: View {
    @State private var lastAction = "None"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Notification with Actions")
                .font(.headline)
            
            Text("Last Action: \(lastAction)")
                .padding()
                .background(.gray.opacity(0.1))
                .clipShape(.rect(cornerRadius: 8))
            
            Button("Schedule with Actions") {
                registerCategories()
                scheduleActionNotification()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Long press the notification to see actions")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
    
    private func registerCategories() {
        let acceptAction = UNNotificationAction(
            identifier: "ACCEPT_ACTION",
            title: "Accept",
            options: [.foreground]
        )
        
        let declineAction = UNNotificationAction(
            identifier: "DECLINE_ACTION",
            title: "Decline",
            options: [.destructive]
        )
        
        let remindAction = UNNotificationAction(
            identifier: "REMIND_ACTION",
            title: "Remind Later",
            options: []
        )
        
        let category = UNNotificationCategory(
            identifier: "MEETING_INVITATION",
            actions: [acceptAction, declineAction, remindAction],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    private func scheduleActionNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Meeting Invitation"
        content.body = "Team standup at 10:00 AM"
        content.sound = .default
        content.categoryIdentifier = "MEETING_INVITATION"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}

// MARK: - Scheduled Notification

struct ScheduledNotificationExample: View {
    @State private var selectedDate = Date.now.addingTimeInterval(60)
    @State private var notificationTitle = "Reminder"
    @State private var notificationBody = "Don't forget!"
    @State private var isScheduled = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Schedule Notification")
                .font(.headline)
            
            Form {
                Section("Content") {
                    TextField("Title", text: $notificationTitle)
                    TextField("Message", text: $notificationBody)
                }
                
                Section("Time") {
                    DatePicker("When", selection: $selectedDate, in: Date.now...)
                }
                
                Section {
                    Button("Schedule") {
                        scheduleNotification()
                    }
                    .disabled(notificationTitle.isEmpty)
                    
                    if isScheduled {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Notification scheduled!")
                        }
                    }
                }
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationBody
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: selectedDate
        )
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    isScheduled = true
                    
                    // Reset after 3 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isScheduled = false
                    }
                }
            }
        }
    }
}

// MARK: - Repeating Notification

struct RepeatingNotificationExample: View {
    @State private var hour = 9
    @State private var minute = 0
    @State private var selectedDays: Set<Int> = [2, 3, 4, 5, 6] // Mon-Fri
    
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Repeating Notification")
                .font(.headline)
            
            Form {
                Section("Time") {
                    HStack {
                        Picker("Hour", selection: $hour) {
                            ForEach(0..<24, id: \.self) { h in
                                Text("\(h)").tag(h)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80)
                        
                        Text(":")
                        
                        Picker("Minute", selection: $minute) {
                            ForEach(0..<60, id: \.self) { m in
                                Text(String(format: "%02d", m)).tag(m)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80)
                    }
                    .frame(height: 100)
                }
                
                Section("Days") {
                    HStack {
                        ForEach(0..<7, id: \.self) { day in
                            Button {
                                toggleDay(day)
                            } label: {
                                Text(weekdays[day])
                                    .font(.caption)
                                    .frame(width: 36, height: 36)
                                    .background(selectedDays.contains(day + 1) ? .blue : .gray.opacity(0.2))
                                    .foregroundStyle(selectedDays.contains(day + 1) ? .white : .primary)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                
                Section {
                    Button("Schedule Daily Reminders") {
                        scheduleRepeatingNotifications()
                    }
                    
                    Button("Cancel All Reminders", role: .destructive) {
                        cancelAllNotifications()
                    }
                }
            }
        }
    }
    
    private func toggleDay(_ day: Int) {
        let weekday = day + 1 // Calendar weekdays are 1-indexed
        if selectedDays.contains(weekday) {
            selectedDays.remove(weekday)
        } else {
            selectedDays.insert(weekday)
        }
    }
    
    private func scheduleRepeatingNotifications() {
        // Cancel existing
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for weekday in selectedDays {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.weekday = weekday
            
            let content = UNMutableNotificationContent()
            content.title = "Daily Reminder"
            content.body = "Time for your scheduled task!"
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            
            let request = UNNotificationRequest(
                identifier: "daily-\(weekday)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

// MARK: - Notification Badge

struct NotificationBadgeExample: View {
    @State private var badgeCount = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text("App Badge")
                .font(.headline)
            
            ZStack(alignment: .topTrailing) {
                Image(systemName: "app.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                
                if badgeCount > 0 {
                    Text("\(badgeCount)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(.red)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
            
            Stepper("Badge Count: \(badgeCount)", value: $badgeCount, in: 0...99)
                .padding(.horizontal)
            
            HStack {
                Button("Set Badge") {
                    setBadge(count: badgeCount)
                }
                
                Button("Clear Badge") {
                    badgeCount = 0
                    setBadge(count: 0)
                }
            }
            .buttonStyle(.bordered)
            
            Text("Badge appears on app icon")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
    
    private func setBadge(count: Int) {
        UNUserNotificationCenter.current().setBadgeCount(count)
    }
}

// MARK: - Pending Notifications List

struct PendingNotificationsExample: View {
    @State private var pendingNotifications: [UNNotificationRequest] = []
    
    var body: some View {
        NavigationStack {
            List {
                if pendingNotifications.isEmpty {
                    ContentUnavailableView(
                        "No Pending Notifications",
                        systemImage: "bell.slash",
                        description: Text("Schedule some notifications to see them here")
                    )
                } else {
                    ForEach(pendingNotifications, id: \.identifier) { notification in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(notification.content.title)
                                .font(.headline)
                            
                            Text(notification.content.body)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("ID: \(notification.identifier)")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .onDelete(perform: deleteNotifications)
                }
            }
            .navigationTitle("Pending (\(pendingNotifications.count))")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Refresh") {
                        loadPendingNotifications()
                    }
                }
                
                ToolbarItem(placement: .destructiveAction) {
                    Button("Clear All", role: .destructive) {
                        clearAllNotifications()
                    }
                }
            }
        }
        .onAppear {
            loadPendingNotifications()
        }
    }
    
    private func loadPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                pendingNotifications = requests
            }
        }
    }
    
    private func deleteNotifications(at offsets: IndexSet) {
        let identifiers = offsets.map { pendingNotifications[$0].identifier }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        pendingNotifications.remove(atOffsets: offsets)
    }
    
    private func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        pendingNotifications.removeAll()
    }
}

// MARK: - Notification Manager

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var isAuthorized = false
    
    private init() {
        checkAuthorizationStatus()
    }
    
    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            await MainActor.run {
                isAuthorized = granted
            }
            return granted
        } catch {
            return false
        }
    }
    
    func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleNotification(
        title: String,
        body: String,
        timeInterval: TimeInterval,
        identifier: String = UUID().uuidString
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

// MARK: - Preview

#Preview("Basic") {
    BasicNotificationExample()
}

#Preview("With Actions") {
    NotificationActionsExample()
}

#Preview("Scheduled") {
    ScheduledNotificationExample()
}

#Preview("Repeating") {
    RepeatingNotificationExample()
}

#Preview("Badge") {
    NotificationBadgeExample()
}

#Preview("Pending List") {
    PendingNotificationsExample()
}
