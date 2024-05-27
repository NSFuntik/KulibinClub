//
//  Events.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI

struct EventView: View {
    var event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.date)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Image(event.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            Text(event.title)
                .font(.headline)
            Text(event.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct EventListView: View {
    @State private var selectedDate = Date()
    @StateObject private var viewModel = EventViewModel()

    var body: some View {
        VStack {
            DatePicker(
                "Выберите дату",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.events.filter { $0.date == formattedDate(selectedDate) }) { event in
                        EventView(event: event)
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Мероприятия")
        .onAppear {
            self.viewModel.fetchEvents()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
