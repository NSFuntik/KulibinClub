//
//  Models.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 21.05.2024.
//
import Combine
import FirebaseFirestore
import Foundation
/// Представляет собой курс, предлагаемый клубом.
struct Course: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var category: String = " "
    var title: String = " "
    var description: String = " "
    var details: String = " "
    var benefits: [String] = []
    var schedule: String = " "
    var ageGroup: String = " "
}



let exampleCourses: [Course] = [
    Course(
        category: "Робототехника",
        title: "Основы конструирования и программирования",
        description: "WeDo, SPIKE, KIK, Mindstorms EV3, Arduino, RoboBasics",
        benefits: [
            "Развитие моторики и координации движений",
            "Улучшение логического мышления",
            "Социальное развитие",
        ],
        schedule: "60 часов",
        ageGroup: "6-8 лет"
    ),
    Course(category: "Программирование", title: "Scratch", description: "Игровое программирование"),
    Course(category: "Программирование", title: "Python", description: "Web программирование и дизайн"),
    Course(category: "Программирование", title: "Web программирование и дизайн", description: "Изучаем веб-дизайн и разработку"),
    Course(category: "Программирование", title: "Мультимедийные элементы и игры", description: "Создание игр и интерактивных элементов"),
    Course(category: "Компьютерная графика и 3D", title: "3D моделирование", description: "Малые архитектурные формы"),
    Course(category: "Курсы для взрослых", title: "Курсы повышения квалификации", description: "Повышение квалификации для взрослых"),
]

/// Представляет мероприятие, организованное клубом.
struct Event: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var date: String = " "
    var title: String = " "
    var description: String = " "
    var image: String = " "
}

class EventService: ObservableObject {
    static let shared = EventService()
    private let cache = URLCache.shared
    @Published var events: [Event] = []
    @Published var cancellables = Set<AnyCancellable>()
    private let networkMonitor = NetworkMonitor()

    init() {
        networkMonitor.$isConnected.sink { isConnected in
            if isConnected {
                self.fetchEvents { events in
                    self.events = events
                }
            } else {
                self.loadCachedEvents()
            }
        }.store(in: &cancellables)
    }

    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        let url = URL(string: "http://127.0.0.1:5000/events")!
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data, let response = response {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cachedResponse, for: request)

                if let events = try? JSONDecoder().decode([Event].self, from: data) {
                    DispatchQueue.main.async {
                        completion(events)
                    }
                }
            }
        }.resume()
    }

    private func loadCachedEvents() {
        let url = URL(string: "http://127.0.0.1:5000/events")!
        let request = URLRequest(url: url)

        if let cachedResponse = cache.cachedResponse(for: request),
           let events = try? JSONDecoder().decode([Event].self, from: cachedResponse.data) {
            DispatchQueue.main.async {
                self.events = events
            }
        }
    }
}

/// Представляет часто задаваемый вопрос.
struct FAQ: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var question: String = " "
    var answer: String = " "
}

/// Представляет обновление новостей.
struct News: Identifiable, Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var date: String? = " "
    var title: String? = " "
    var description: String? = " "
    var images: [String]? = []
}

class NewsService: ObservableObject {
    static let shared = NewsService()
    private let cache = URLCache.shared
    @Published var news: [News] = []
    @Published var cancellables = Set<AnyCancellable>()

    private let networkMonitor = NetworkMonitor()

    init() {
        networkMonitor.$isConnected.sink { isConnected in
            if isConnected {
                self.fetchNews { news in
                    self.news = news
                }
            } else {
                self.loadCachedNews()
            }
        }.store(in: &cancellables)
    }

    func fetchNews(completion: @escaping ([News]) -> Void) {
        let url = URL(string: "http://127.0.0.1:5000/news")!
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data, let response = response {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                self.cache.storeCachedResponse(cachedResponse, for: request)

                if let news = try? JSONDecoder().decode([News].self, from: data) {
                    DispatchQueue.main.async {
                        completion(news)
                    }
                }
            }
        }.resume()
    }

    private func loadCachedNews() {
        let url = URL(string: "http://127.0.0.1:5000/news")!
        let request = URLRequest(url: url)

        if let cachedResponse = cache.cachedResponse(for: request),
           let news = try? JSONDecoder().decode([News].self, from: cachedResponse.data) {
            DispatchQueue.main.async {
                self.news = news
            }
        }
    }
}
