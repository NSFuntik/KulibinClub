//
//  SettingsView.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI
import Firebase

struct SettingsView: View {
    @State private var isSubscribedToEvents: Bool = true
    @State private var isSubscribedToNews: Bool = true
    
    var body: some View {
        Form {
            Section(header: Text("Подписки на уведомления")) {
                Toggle(isOn: $isSubscribedToEvents) {
                    Text("События")
                }.onChange(of: isSubscribedToEvents) { value in
                    if value {
                        Messaging.messaging().subscribe(toTopic: "events") { error in
                            if let error = error {
                                print("Ошибка подписки на тему событий: \(error.localizedDescription)")
                            } else {
                                print("Успешно подписан на тему событий")
                            }
                        }
                    } else {
                        Messaging.messaging().unsubscribe(fromTopic: "events") { error in
                            if let error = error {
                                print("Ошибка отписки от темы событий: \(error.localizedDescription)")
                            } else {
                                print("Успешно отписан от темы событий")
                            }
                        }
                    }
                }
                
                Toggle(isOn: $isSubscribedToNews) {
                    Text("Новости")
                }.onChange(of: isSubscribedToNews) { value in
                    if value {
                        Messaging.messaging().subscribe(toTopic: "news") { error in
                            if let error = error {
                                print("Ошибка подписки на тему новостей: \(error.localizedDescription)")
                            } else {
                                print("Успешно подписан на тему новостей")
                            }
                        }
                    } else {
                        Messaging.messaging().unsubscribe(fromTopic: "news") { error in
                            if let error = error {
                                print("Ошибка отписки от темы новостей: \(error.localizedDescription)")
                            } else {
                                print("Успешно отписан от темы новостей")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Настройки")
        .onAppear {
            // Здесь можно загрузить текущее состояние подписок из UserDefaults или другого источника
        }
    }
}
