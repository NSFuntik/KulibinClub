//
//  History.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//


import SwiftUI

struct HistoryEvent: Identifiable {
    var id = UUID()
    var year: String
    var description: String
}

let historyEvents: [HistoryEvent] = [
    HistoryEvent(year: "2013", description: "Открытие клуба"),
    HistoryEvent(year: "2014", description: "Способствуем развитию детей в сфере робототехники и готовим их к соревнованиям"),
    HistoryEvent(year: "2015", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
    HistoryEvent(year: "2016", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
    HistoryEvent(year: "2017", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
    HistoryEvent(year: "2018", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
    HistoryEvent(year: "2019", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
    HistoryEvent(year: "2020", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
    HistoryEvent(year: "2021", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
    HistoryEvent(year: "2022", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
    HistoryEvent(year: "2023", description: "Впервые участие в Республиканском робототехническом фестивале «РобоФест». Финалисты этапа Всероссийской робототехнической олимпиады"),
]

struct HistoryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("История создания")
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("Kulibin.club — это клуб детского научно-технического творчества, где дети разных возрастов могут заниматься робототехникой, программированием и другими интересными направлениями. Клуб был основан в 2013 году и с тех пор активно участвует в различных соревнованиях и мероприятиях.")
                    .font(.body)
                
                ForEach(historyEvents) { event in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(event.year)
                            .font(.headline)
                        Text(event.description)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("История создания")
    }
}
