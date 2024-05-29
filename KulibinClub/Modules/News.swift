//
//  News.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import Foundation

let exampleNews: [News] = [
    News(date: "12.19.2023", title: "Итоги онлайн-конкурса «Большое лего путешествие» 13 новость", description: "Итоги онлайн-конкурса «Большое лего ..."),
    News(date: "11.12.2023", title: "Итоги онлайн-конкурса «Большое лего путешествие» 12 новость", description: "Итоги онлайн-конкурса «Большое лего ..."),
    News(date: "11.11.2023", title: "Итоги онлайн-конкурса «Большое лего путешествие» 11 новость", description: "Итоги онлайн-конкурса «Большое лего ..."),
    // Добавьте больше новостей по необходимости
]

import SwiftUI

struct NewsListView: View {
//    @ObservedObject var viewModel = NewsViewModel()
    @State var newsList: Array<News> = exampleNews

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Новости")
                    .font(.largeTitle)
                    .padding(.top)

                ForEach(Array(newsList.enumerated()), id: \.element.id) { index, news in
                    NavigationLink(destination: NewsDetailView(news: news)) {
                        NewsView(index: index, news: news)
                    }
                    .padding(.bottom, 10)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Новости")
        .task {
            do {
                let endpoint = NewsEndpoint.getNews
                self.newsList = try await FirestoreService.request(endpoint)
            } catch {
                debugPrint("Error: ", error.localizedDescription)
            }
        }
    }

    public enum NewsEndpoint: FirestoreEndpoint {
        case getNews, postNews(dto: News)

        public var path: FirestoreReference {
            switch self {
            case .getNews:
                return firestore.collection("news")
            case let .postNews(dto):
                return firestore.collection("news").document(dto.id ?? UUID().uuidString)
            }
        }

        public var method: FirestoreMethod {
            switch self {
            case .getNews:
                return .get
            case let .postNews(dto):
                return .post(dto)
            }
        }
    }
}

struct NewsView: View {
    let index: Int
    var news: News

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(news.date ?? Date.now.formatted(date: .numeric, time: .omitted))
                .font(.footnote)
                .foregroundColor(.secondary)
            Text(news.title ?? "Новость \(index + 1)")
                .font(.headline)
            Text(news.description ?? "Описание новости \(index + 1)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            NavigationLink(destination: NewsDetailView(news: news)) {
                Text("Подробнее")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct NewsDetailView: View {
    var news: News

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(news.title ?? "")
                    .font(.largeTitle)
                Text(news.date ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(news.description ?? "")
                    .font(.body)
                Spacer()
            }
            .padding()
        }
        .navigationTitle(news.title ?? "")
    }
}

struct NewsCardView: View {
    let newsTitle: String
    let newsDescription: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(newsTitle)
                .font(.headline)
            Text(newsDescription)
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
