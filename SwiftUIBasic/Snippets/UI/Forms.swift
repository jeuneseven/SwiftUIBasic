//
//  Forms.swift
//  SwiftUIBasic
//
//  Form, Picker, TextField, Stepper, DatePicker, and input controls
//

import SwiftUI

// MARK: - Basic Form

struct BasicFormExample: View {
    @State private var name = ""
    @State private var email = ""
    @State private var enableNotifications = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Personal Info") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                }
                
                Section("Settings") {
                    Toggle("Enable Notifications", isOn: $enableNotifications)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - TextField Variations

struct TextFieldVariationsExample: View {
    @State private var username = ""
    @State private var password = ""
    @State private var bio = ""
    
    var body: some View {
        Form {
            Section("Basic") {
                TextField("Username", text: $username)
                    .textContentType(.username)
                
                SecureField("Password", text: $password)
                    .textContentType(.password)
            }
            
            Section("Styled") {
                TextField("Rounded Border", text: $username)
                    .textFieldStyle(.roundedBorder)
            }
            
            Section("Multi-line") {
                // axis: .vertical allows multi-line input
                TextField("Bio", text: $bio, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            Section("TextEditor") {
                TextEditor(text: $bio)
                    .frame(height: 100)
            }
        }
    }
}

// MARK: - Picker Styles

struct PickerStylesExample: View {
    let options = ["Option A", "Option B", "Option C", "Option D"]
    @State private var selection1 = "Option A"
    @State private var selection2 = "Option A"
    @State private var selection3 = "Option A"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Default (Navigation)") {
                    // id: \.self - SwiftUI needs unique identifier for each item
                    Picker("Select", selection: $selection1) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                
                Section("Segmented") {
                    Picker("Select", selection: $selection2) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Inline") {
                    Picker("Select", selection: $selection3) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
            .navigationTitle("Picker Styles")
        }
    }
}

// MARK: - Menu Picker

struct MenuPickerExample: View {
    let colors = ["Red", "Green", "Blue", "Yellow"]
    @State private var selectedColor = "Red"
    
    var body: some View {
        Form {
            Picker("Color", selection: $selectedColor) {
                ForEach(colors, id: \.self) { color in
                    Text(color)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

// MARK: - Stepper

struct StepperExample: View {
    @State private var quantity = 1
    @State private var hours = 8.0
    
    var body: some View {
        Form {
            Section("Integer Stepper") {
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
            }
            
            Section("Decimal Stepper") {
                Stepper("\(hours.formatted()) hours",
                        value: $hours,
                        in: 4...12,
                        step: 0.5)
            }
            
            Section("Custom Stepper") {
                Stepper {
                    Text("Value: \(quantity)")
                } onIncrement: {
                    quantity += 2
                } onDecrement: {
                    quantity -= 1
                }
            }
        }
    }
}

// MARK: - DatePicker

struct DatePickerExample: View {
    @State private var selectedDate = Date.now
    @State private var selectedTime = Date.now
    @State private var selectedDateTime = Date.now
    
    var body: some View {
        Form {
            Section("Date Only") {
                DatePicker("Select Date",
                           selection: $selectedDate,
                           displayedComponents: .date)
            }
            
            Section("Time Only") {
                DatePicker("Select Time",
                           selection: $selectedTime,
                           displayedComponents: .hourAndMinute)
            }
            
            Section("Date and Time") {
                DatePicker("Select",
                           selection: $selectedDateTime)
            }
            
            Section("With Range (Future Only)") {
                DatePicker("Select Date",
                           selection: $selectedDate,
                           in: Date.now...,
                           displayedComponents: .date)
            }
            
            Section("Hidden Label") {
                DatePicker("Hidden", selection: $selectedDate)
                    .labelsHidden()
            }
            
            Section("Formatted Output") {
                Text(selectedDate.formatted(date: .long, time: .shortened))
                Text(selectedDate, format: .dateTime.day().month().year())
            }
        }
    }
}

// MARK: - Slider

struct SliderExample: View {
    @State private var value = 50.0
    @State private var volume = 0.5
    
    var body: some View {
        Form {
            Section("Basic Slider") {
                Slider(value: $value, in: 0...100)
                Text("Value: \(Int(value))")
            }
            
            Section("With Step") {
                Slider(value: $value, in: 0...100, step: 10)
                Text("Value: \(Int(value))")
            }
            
            Section("With Labels") {
                Slider(value: $volume, in: 0...1) {
                    Text("Volume")
                } minimumValueLabel: {
                    Image(systemName: "speaker")
                } maximumValueLabel: {
                    Image(systemName: "speaker.wave.3")
                }
            }
        }
    }
}

// MARK: - Toggle Styles

struct ToggleStylesExample: View {
    @State private var isOn1 = true
    @State private var isOn2 = false
    
    var body: some View {
        Form {
            Section("Switch (Default)") {
                Toggle("Enable Feature", isOn: $isOn1)
            }
            
            Section("Button Style") {
                Toggle("Enable Feature", isOn: $isOn2)
                    .toggleStyle(.button)
            }
            
            Section("With Tint") {
                Toggle("Custom Color", isOn: $isOn1)
                    .tint(.purple)
            }
        }
    }
}

// MARK: - Form Validation

struct FormValidationExample: View {
    @State private var username = ""
    @State private var email = ""
    
    var isFormValid: Bool {
        username.count >= 3 && email.contains("@")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Username (min 3 chars)", text: $username)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                }
                
                Section {
                    Button("Create Account") {
                        print("Account created!")
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Sign Up")
        }
    }
}

// MARK: - Preview

#Preview("Basic Form") {
    BasicFormExample()
}

#Preview("TextField Variations") {
    TextFieldVariationsExample()
}

#Preview("Picker Styles") {
    PickerStylesExample()
}

#Preview("Menu Picker") {
    MenuPickerExample()
}

#Preview("Stepper") {
    StepperExample()
}

#Preview("DatePicker") {
    DatePickerExample()
}

#Preview("Slider") {
    SliderExample()
}

#Preview("Toggle Styles") {
    ToggleStylesExample()
}

#Preview("Form Validation") {
    FormValidationExample()
}
