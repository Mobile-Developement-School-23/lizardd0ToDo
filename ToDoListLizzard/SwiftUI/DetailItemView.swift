//
//  DetailItemView.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 21.07.2023.
//

import SwiftUI
import UIKit


struct DetailItemView: View {
    @State private var showCalendar = false
    @State var selectedDate: Date = Date()
    @State var item: TodoItem
    @State private var showDeadline = false
    var body: some View {
        NavigationStack {
            ScrollView() {
                text
                
                VStack(alignment: .leading) {
                    
                    importanceStack
                    
                    Divider()
                    
                    deadlineStack
                    
                    if showDeadline && showCalendar {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            DatePicker("Select Date", selection: $selectedDate)
                                .padding(.horizontal)
                                .datePickerStyle(.graphical)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color(.tertiarySystemBackground))
                .frame(width: 360)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                deleteButton
                
            }
            
            .background(Color(uiColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)))
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button("Сохранить") {}
                        .bold()
                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    
//                    Button("Отменить") {}
//                }
            }
        }
    }
    
    private var text: some View {
        TextField("Что нужно сделать?", text: $item.text)
            .frame(height: 120)
            .textFieldStyle(PlainTextFieldStyle())
            .frame(width: 360)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding([.leading, .trailing, .top], 16)
            .background(Color(.tertiarySystemBackground))
        
    }
    private var importanceStack: some View {
        HStack(alignment: .center, spacing: 16) {
            Text("Важность")
//                .padding()
            Spacer()
            Picker("Importance", selection: $item.importance) {
                Image(systemName: "arrow.down").tag(TodoItem.Importance.unimportant)
                Text("нет").tag(TodoItem.Importance.ordinary)
                Image(systemName: "exclamationmark.2").tag(TodoItem.Importance.important)
                //                                .fontWeight(.bold)
                //                                .foregroundColor(.red)
            }.pickerStyle(.segmented)
                .frame(width: 150)

        }.padding(.leading, 16)
            .padding(.trailing, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .center)

    }
    
    private var deadlineStack: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack {
                Text("Сделать до")
                if showDeadline {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        deadlineView
                    }
                }
            }
            Toggle("", isOn: $showDeadline)
        }.padding(.leading, 16)
            .padding(.trailing, 12)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56, alignment: .center)
    }
    
    private let formatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"

        return formatter
    }()

    private var deadlineView: some View {
        Text(formatter.string(from: item.deadline ?? Date()))
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.blue)
            .bold()
            .onTapGesture {
                showCalendar.toggle()
            }
    }
    
    private var deleteButton: some View {
        GeometryReader { geometry in
            Button {
                
            } label: {
                ZStack {
                    Rectangle()
                        .frame(width: geometry.size.width * 0.915, height: 56)
                        .foregroundColor(Color(.tertiarySystemBackground))
                        .cornerRadius(15)
                        .padding()
                    Text("Удалить")
                        .foregroundColor(Color(.red))
                        .padding(.vertical)
                        .font(.system(size: 17, weight: .regular))
                }
            }
        }
    }
}

struct DetailItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailItemView(item: TodoItem(text: "hahadvv", importance: TodoItem.Importance.important, deadline: Date(), flag: false))
    }
}
