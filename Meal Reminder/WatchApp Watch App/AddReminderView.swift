//
//  AddReminderView.swift
//  WatchApp Watch App
//
//  Created by Mashael Alharbi on 18/06/1444 AH.
//

import SwiftUI
import CoreData
import WatchKit
import WatchDatePicker
import UserNotifications

struct AddReminderView: View {
    
    @FetchRequest(
        entity: ReminderEntity.entity(),
        sortDescriptors:[NSSortDescriptor(keyPath: \ReminderEntity.name, ascending: true)])
    var items: FetchedResults<ReminderEntity>
    
    @State private var isPresentedFullScreenCover = false
    @State private var isPrsnt = false
    
    @State var AddName : String = ""
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var value = Calendar.current.date(bySettingHour: 00, minute: 00, second: 0, of: Date())!

    
    static let formatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute]
    return formatter
    }()
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 6){
                
                
                TextField("Name?", text: $AddName)
                    .font(.system(size: 16))
                    .frame(width: 190, height: 50.0)
                    .padding(.leading)
                    .accessibilityLabel(Text("Name?"))
                 Spacer()
                
                Text("When is your day starts?")
//                  .multilineTextAlignment(.leading)
                  .accessibilityLabel(Text("When is your day starts?"))


              .font(.system(size: 12, weight: .semibold))
              .padding(.leading, -20.0)
              .padding()
              
              
              VStack (alignment: .leading){

                      DatePicker("Time", selection: $value, displayedComponents: [.hourAndMinute])
                        .datePickerInteractionStyle(.navigationLink)
                        .multilineTextAlignment(.leading)
                        .frame(width: 190, height: 50.0)
                        .buttonStyle(BorderedButtonStyle(tint: .gray))
                        .accessibilityLabel(Text("Time"))
//                        .padding()
                  
                  
                    }

                Text("what Schedule suits you?")
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.leading, -20.0)
                    .accessibilityLabel(Text("what Schedule suits you?"))
                    .padding()
                VStack(alignment: .leading){
                    HStack (alignment: .center, spacing: 8) {
                        Button(action:   {
                            scheduleNotification1()
                            Authorization()
                            // Do something here
                        }, label: {
                            Text("3 Meals")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .accessibilityLabel(Text("3 Meals"))
                        })
                        .frame(width: 90, height: 50.0)
                        .buttonStyle(BorderedButtonStyle(tint: Color("babyred").opacity(250)))

                        Button(action:   {
                            scheduleNotification4()
                            Authorization()
                            // Do something here
                        }, label: {
                            Text("4 Meals")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .accessibilityLabel(Text("4 Meals"))
                        })
                        .frame(width: 90, height: 50.0)
                        .buttonStyle(BorderedButtonStyle(tint: Color("babypurple").opacity(250)))
                    }
                }
                .padding(.horizontal)

                VStack{
                    HStack (alignment: .center, spacing: 8) {
                        Button(action:   {
                            scheduleNotification5()
                            Authorization()
                            // Do something here
                        }, label: {
                            Text("5 Meals")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .accessibilityLabel(Text("5 Meals"))
                        })
                        .frame(width: 90, height: 50.0)
                        .buttonStyle(BorderedButtonStyle(tint: Color("babyyello").opacity(250)))
                        
                        Button(action:   {
                            scheduleNotification()
                            Authorization()
                            // Do something here
                        }, label: {
                            Text("12 Meals")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .accessibilityLabel(Text("12 Meals"))
                        })
                        .frame(width: 90, height: 50.0)
                        .buttonStyle(BorderedButtonStyle(tint: Color("babyblue").opacity(250)))
                    }
                }
                
                    Button(action: {
                        addItem()
                        print(items)
                        //                     هنا البرينت \٩٩٨\
                        
                    }, label: {
                        Text("Add")
                        
                           
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 190, height: 50.0)
                        // .frame(width: 50)
                        // .frame(height: 30)
                            .background(Color(.purple))
                            .cornerRadius(10)
                            .accessibilityLabel(Text("Add"))
                        
                    })
                    //                .fullScreenCover(isPresented : $isPrsnt) {ContentView()}
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 20.0)
                }
            
            .navigationTitle("Reminders")
            .foregroundColor(.white)
            .accessibilityLabel(Text("Reminders"))
        }
        
            }
      
    
    
    
        private func addItem() {
            withAnimation {
                let newItem = ReminderEntity(context: viewContext)
                 newItem.name = AddName
                print("This is the date:\(value.description)")
                print("This is the date:\(value.formatted())")
                newItem.date = value
                
                do {
                    try viewContext.save()
                    presentationMode.wrappedValue.dismiss()

                } catch {
    
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    
     
    func scheduleNotification(){
       
            let content = UNMutableNotificationContent()
            content.title = "Carefull!"
            content.subtitle = "Don't forget your meal"
            content.sound = .default
            content.categoryIdentifier = "myCategory"
            let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
        UserNotifications.UNUserNotificationCenter.current().setNotificationCategories([category])
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (2 * 60 * 60), repeats: true)
            let request = UNNotificationRequest(identifier: "Meal", content: content, trigger: trigger)
        for _ in 0...12 {
            UserNotifications.UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                print(error.localizedDescription)
                }else{
                print("scheduled successfully")
                }
                }
                }
        }
      
  
//      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(2 * 60 * 60), repeats: true)
//
//      let request = UNNotificationRequest(identifier: "text", content: content, trigger: trigger)
      
//      UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleNotification1(){
        let content = UNMutableNotificationContent()
        content.title = "Carefull!"
        content.subtitle = "Don't forget your meal"
        content.sound = .default
        content.categoryIdentifier = "myCategory"
        let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
    UserNotifications.UNUserNotificationCenter.current().setNotificationCategories([category])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (5 * 60 * 60), repeats: true)
        let request = UNNotificationRequest(identifier: "Meal", content: content, trigger: trigger)
        for _ in 0...3 {
            UserNotifications.UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                print(error.localizedDescription)
                }else{
                print("scheduled successfully")
                }
                }
                }
        }
//      let content = UNMutableNotificationContent()
//      content.title = "Reminder"
//      content.body = "Don't forget your meal"
//      content.sound = .default
//
//
//      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(5 * 60 * 60), repeats: true)
//
//      let request = UNNotificationRequest(identifier: "text", content: content, trigger: trigger)
//
//      UNUserNotificationCenter.current().add(request)
//    }
    
    func scheduleNotification4(){
        let content = UNMutableNotificationContent()
        content.title = "Carefull!"
        content.subtitle = "Don't forget your meal"
        content.sound = .default
        content.categoryIdentifier = "myCategory"
        let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
    UserNotifications.UNUserNotificationCenter.current().setNotificationCategories([category])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (4 * 60 * 60), repeats: true)
        let request = UNNotificationRequest(identifier: "Meal", content: content, trigger: trigger)
        for _ in 0...4 {
            UserNotifications.UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                print(error.localizedDescription)
                }else{
                print("scheduled successfully")
                }
                }
                }
        }
    
    
    func scheduleNotification5(){
        let content = UNMutableNotificationContent()
        content.title = "Carefull!"
        content.subtitle = "Don't forget your meal"
        content.sound = .default
        content.categoryIdentifier = "myCategory"
        let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
    UserNotifications.UNUserNotificationCenter.current().setNotificationCategories([category])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: (3 * 60 * 60), repeats: true )
        let request = UNNotificationRequest(identifier: "Meal", content: content, trigger: trigger)
        for _ in 0...5 {
            UserNotifications.UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                print(error.localizedDescription)
                }else{
                print("scheduled successfully")
                }
                }
                }
        }
func Authorization(){
UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
if success{
print("All set")
} else if let error = error {
print(error.localizedDescription)
}
}
}



struct AddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReminderView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
