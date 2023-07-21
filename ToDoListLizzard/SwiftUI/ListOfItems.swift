//
//  ListOfItems.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 19.07.2023.
//

import SwiftUI

struct ListOfItems: View {
    @State var items: [TodoItem]
    @State private var isShowOrHide = ShowOrHide.show
    @State var buttonTitle: String = "Скрыть"
    var body: some View {
        let count = items.filter({$0.flag == true}).count
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(uiColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0))
                VStack {
                    list
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(Color(.systemBlue))
                    
                }
            }
                .navigationTitle("Мои дела")
        }
    }

    private var list: some View {
        List {
            let count = items.filter({$0.flag == true}).count
            Section {
                ForEach(items, id: \.id) { item in
                    NavigationLink {
                        DetailItemView(item: item)
                    } label: {
                        OneItemView(item: item)
                    }
                }
                NavigationLink {
                    DetailItemView(item: defaultItem)
                } label: {
                    newTask
                }
            } header: {
                HStack {
                    Text("Выполнено - \(count)")
                        .foregroundColor(.gray)
                        .font(.system(size: 15, weight: .regular))
                    Spacer()
                    Button(buttonTitle, action: {
                        if buttonTitle == "Скрыть" {
                            buttonTitle = "Показать"
                        } else {
                            buttonTitle = "Скрыть"
                        }
                        
                    })
                    .font(.system(size: 15, weight: .regular))
                    .bold()
                }
            }
            .textCase(nil)
            .swipeActions {
                Button {
                    
                } label: {
                    Image(systemName: "trash.fill")
                }
                .tint(.red)
            }
            .swipeActions(edge: .leading) {
                Button {
                    
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                }
                .tint(.green)
            }
        }.listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)))
    }
    private var newTask: some View {
        HStack(spacing: 13) {
            Text("Новое")
                .font(.body)
                .foregroundColor(Color(.gray))
        }
        .padding(.vertical, 8)
    }
}

struct ListOfItems_Previews: PreviewProvider {
    static var previews: some View {
        ListOfItems(items: listOfItems)
    }
}

