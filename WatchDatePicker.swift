//
//  WatchDatePicker.swift
//  uAssignment Watch WatchKit Extension
//
//  Created by Ben Fein on 11/21/20.
//  Copyright © 2020 Ben Fein. All rights reserved.
//

import SwiftUI

struct WatchDatePicker: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    @State var thirty = [String]()
    @State var thirtyOne = [String]()
    @State var twentyEight = [String]()
    @State var twentyNine = [String]()
    @State var days = [String]()
    @State var years = [String]()
    @State var monthSelected = false
    @State var currentYear = ""
    @State var currentDate:String?
    @State var month = ""
    @State var day = ""
    @State var firstLoad = true
    @Binding var dueDate: Date
    enum MonthList {
        case Jan
        case Feb
        case Mar
        case Apr
        case May
        case Jun
        case Jul
        case Aug
        case Sep
        case Oct
        case Nov
        case Dec
        case NULL
    }
    init(dueDate: Binding<Date>){
        self._dueDate = dueDate
        let formatM = DateFormatter()
        formatM.dateFormat = "MMM"
        let formatD = DateFormatter()
        formatD.dateFormat = "d"
        let formatY = DateFormatter()
        formatY.dateFormat = "yyyy"
        currentYear = formatY.string(from: dueDate.wrappedValue)
        day = formatD.string(from: dueDate.wrappedValue)
        month = formatM.string(from: dueDate.wrappedValue)
    }
    func setup(){
        if(firstLoad == true){
            let formatM = DateFormatter()
            formatM.dateFormat = "MMM"
            let formatD = DateFormatter()
            formatD.dateFormat = "d"
            let formatY = DateFormatter()
            formatY.dateFormat = "yyyy"
            currentYear = formatY.string(from: $dueDate.wrappedValue)
            day = formatD.string(from: $dueDate.wrappedValue)
            month = formatM.string(from: $dueDate.wrappedValue)
            for i in 1...28{
                twentyEight.append("\(i)")
                twentyNine.append("\(i)")
                thirty.append("\(i)")
                thirtyOne.append("\(i)")
            }
            twentyNine.append("29")
            thirty.append("29")
            thirtyOne.append("29")
            thirty.append("30")
            thirtyOne.append("30")
            thirtyOne.append("31")
            firstLoad = false
        }
    }
    func isLeapYear(year: Int) -> Bool{
        return year % 4 == 0
    }
    func getDaysInMonth(month: MonthList) -> Int{
        switch(month){
        case .Jan:
            return 31
        case .Feb:
            return 29
        case .Mar:
            return 31
        case .Apr:
            return 30
        case .May:
            return 31
        case .Jun:
            return 30
        case .Jul:
            return 31
        case .Aug:
            return 31
        case .Sep:
            return 30
        case .Oct:
            return 31
        case .Nov:
            return 30
        case .Dec:
            return 31
        case .NULL:
            return 1
        }
    }
    func getEnum(m: String) -> MonthList{
        switch(m){
        case "Jan":
            return MonthList.Jan
        case "Feb":
            return MonthList.Feb
        case "Mar":
            return MonthList.Mar
        case "Apr":
            return MonthList.Apr
        case "May":
            return MonthList.May
        case "Jun":
            return MonthList.Jun
        case "Jul":
            return MonthList.Jul
        case "Aug":
            return MonthList.Aug
        case "Sep":
            return MonthList.Sep
        case "Oct":
            return MonthList.Oct
        case "Nov":
            return MonthList.Nov
        case "Dec":
            return MonthList.Dec
        default:
            return MonthList.NULL
        }
    }
    func genDates(){
        days.removeAll()
        for i in 1...29{
            thirty.append("\(i)")
            thirtyOne.append("\(i)")
            twentyNine.append("\(i)")
        }
        thirty.append("30")
        thirtyOne.append("30")
        thirtyOne.append("31")
    }
    func genYears(){
        years.removeAll()
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let year = format.string(from: date)
        
        let yearInt = ((Int(year))) ?? 1985
        for i in stride(from: yearInt, through: yearInt + 4, by: 1) {
            years.append("\(i)")
        }
    }
    
    var body: some View {
        
        Form{
            
            Section{
                Text("\(month ) \(day ), \(currentYear )")
            }.onAppear(perform: {
                genYears()
                
            })
            Section{
                Picker(selection: $month, label: Text("Month")) {
                    ForEach(months, id: \.self) { m in
                        Text(m).tag(m)
                    }
                }.onAppear(perform: {
                    setup()
                })
            }
            if(thirty.count > 0){
                Section{
                    if(getDaysInMonth(month: getEnum(m: month)) == 30){
                        Picker(selection: $day, label: Text("Date")) {
                            ForEach(thirty, id: \.self) { d in
                                Text(d).tag(d)
                            }
                            
                        }
                    }
                    if(getDaysInMonth(month: getEnum(m: month)) == 31){
                        Picker(selection: $day, label: Text("Date")) {
                            ForEach(thirtyOne, id: \.self) { d in
                                Text(d).tag(d)
                            }
                            
                        }
                    }
                    if(getDaysInMonth(month: getEnum(m: month)) == 29 && isLeapYear(year: Int(currentYear) ?? 1970)){
                        Picker(selection: $day, label: Text("Date")) {
                            ForEach(twentyNine, id: \.self) { d in
                                Text(d).tag(d)
                            }
                            
                        }
                    }
                    
                    if(getDaysInMonth(month: getEnum(m: month)) == 29 && isLeapYear(year: Int(currentYear) ?? 1970) == false){
                        Picker(selection: $day, label: Text("Date")) {
                            ForEach(twentyEight, id: \.self) { d in
                                Text(d).tag(d)
                            }
                            
                        }
                    }
                }
                
                Section{
                    Picker(selection: $currentYear, label: Text("Year")) {
                        ForEach(years, id: \.self) { y in
                            Text(y).tag(y)
                        }
                    }
                }
            }
            Section{
                Button(action: {
                    let formater = DateFormatter()
                    formater.dateFormat = "MMM-d-yyyy"
                    dueDate = formater.date(from: "\(month) \(day), \(currentYear)")!
                    self.mode.wrappedValue.dismiss()
                }) {
                    Text("Set Date")
                }
            }
            
        }
        .navigationBarTitle("Select Date")
        .navigationBarBackButtonHidden(true)
    }
}

struct WatchDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        WatchDatePicker(dueDate: .constant(Date()))
    }
}
