//
//  ContentView.swift
//  iGoTheDistance
//
//  Created by Aaron Graves on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var userMeasurement: Double = 0
    @State private var baseUnit: String = "m"
    @State private var convertUnit: String = "m"
    @FocusState private var isDistanceFocused: Bool
    
    let unitsList: [String] = ["m", "km", "ft", "yd", "mi"]
    
    func unitToUnitLength(unit: String) -> UnitLength {
        var myUnit: UnitLength
        // We are returning a UnitLength, default to meters if nothing else matches, but this
        //  should NEVER happen.
        switch unit.lowercased() {
        case "m":
            myUnit = .meters
        case "km":
            myUnit = .kilometers
        case "ft":
            myUnit = .feet
        case "yd":
            myUnit = .yards
        case "mi":
            myUnit = .miles
        default:
            myUnit = .meters
        }
        return myUnit
    }
    
    private var userMeasureToInches: Double {
        Measurement(value: userMeasurement, unit: unitToUnitLength(unit: baseUnit)).converted(to: .inches).value
    }
    
    private var resultMeasurement: Double {
        Measurement(value: userMeasureToInches, unit: .inches).converted(to: unitToUnitLength(unit: convertUnit)).value
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("What would you like to convert?") {
                    // Distance input
                    LabeledContent("Distance") {
                        TextField("Distance", value: $userMeasurement, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($isDistanceFocused)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    // Units picker
                    Picker("Unit", selection: $baseUnit) {
                        ForEach(unitsList, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("What are you converting to?") {
                    // Convert unit selection
                    Picker("Unit", selection: $convertUnit) {
                        ForEach(unitsList, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    HStack {
                        Text(resultMeasurement, format: .number)
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text(convertUnit)
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        
                    }
                    .padding(30 )
                    .frame(maxWidth: .infinity, alignment: Alignment(horizontal: .center, vertical: .bottom))
                }
            }
            .navigationTitle("iGoTheDistance")
            .toolbar {
                if isDistanceFocused {
                    Button("Done") {
                        isDistanceFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
