//
//  OneItemView.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 20.07.2023.
//

import SwiftUI

struct OneItemView: View {
    @State var item: TodoItem
    
    var vPadding: CGFloat {
        if item.deadline != nil {
            return 12
        } else {
            return 16
        }
    }
    
    var body: some View {
        HStack {
            flagButton
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        item.flag.toggle()
                    }
                }
            VStack(alignment: .leading) {
                HStack {
                    if item.importance != TodoItem.Importance.ordinary {
                        Image(systemName: item.importance == TodoItem.Importance.important ? "exclamationmark.2" : "arrow.down")
                            .fontWeight(.bold)
                            .foregroundColor(item.importance == TodoItem.Importance.important ? .red : .gray)
                    }
                    Text(item.text)
                        .lineLimit(3)
                        .strikethrough(item.flag)
                        .foregroundColor(item.flag ? .gray : .black)
                }
                if item.deadline != nil {
                    deadlineView
                }
            }
            Spacer()

        }
        .padding(EdgeInsets(top: vPadding, leading: 0, bottom: vPadding, trailing: 8))
    }
    private let formatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"

        return formatter
    }()

    private var deadlineView: some View {
        HStack {
            Image(systemName: "calendar")
                .imageScale(.small)
            Text(formatter.string(from: item.deadline ?? Date()))
                .font(.system(size: 15, weight: .regular))
        }
        .foregroundColor(.gray)
    }
    
    private var flagButton: some View {
        Image(systemName: item.flag ? "checkmark.circle.fill" : "circle")
            .foregroundColor(getColor())
    }
    
    private func getColor() -> Color {
        if item.flag {
            return .green
        } else if item.importance == TodoItem.Importance.important {
            return .red
        } else {
            return .gray
        }
    }
}

struct OneItemView_Previews: PreviewProvider {
    static var previews: some View {
        OneItemView(item: TodoItem(text: "hahadvv", importance: TodoItem.Importance.important, deadline: Date(), flag: false))
    }
}

