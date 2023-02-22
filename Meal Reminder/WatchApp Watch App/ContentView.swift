//
//  ContentView.swift
//  WatchApp Watch App
//
//  Created by Mashael Alharbi on 18/06/1444 AH.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {

//    let string = NSLocalizedString("Name?", comment: "")
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @FetchRequest(
        entity: ReminderEntity.entity(),
        sortDescriptors:[NSSortDescriptor(keyPath: \ReminderEntity.name, ascending: true)])
    var items: FetchedResults<ReminderEntity>
    
    var body: some View {
        NavigationView {
           
                VStack(alignment: .leading) {
                    
                    Text("Reminders")
                        .accessibilityLabel(Text("Reminders"))
                    NavigationLink(destination: AddReminderView() ,label: {
                        HStack{
                            
                            Image(systemName: "plus.circle.fill")
                            
                                .font(.title2)
                                .frame(maxWidth: .infinity,maxHeight: 65 ,alignment: .center)
                                .background(Color("lightGreen"))
                                .cornerRadius(10)
                                
                                
                            
                        }
                    }).buttonStyle(PlainButtonStyle())
                        
                    VStack(alignment: .leading) {
                        Text("List")
                            .accessibilityLabel(Text("List"))
                        List {
                            ForEach(items) { item in
                                NavigationLink {
                                    
                                    Text(item.name ?? "")
                                    Text(item.date?.formatted() ?? "")

//                                  .formatted(.timeDuration)
//  Text(item.date ?? "")
                                } label: {
                                    
                                    Text(item.name ?? "")
//                                    Text(item.date?.formatted() ?? "")
                                    
                                }
                            }.onDelete(perform: deleteItems )
                           
                        }
                     
                        
                    }.listStyle(PlainListStyle())
                    

                }
            
        }
        
    }
    

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {

                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
