//
//  Product.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI
import FirebaseFirestore

/// Представляет продукт, доступный для покупки.
struct Product: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String = " "
    var description: String = " "
    var price: String = " "
    var imageName: String = " "
    var characteristics: [String: String] = [:]
    var detailedDescription: String = " "
    var specifications: [String] = []
}

let exampleProducts: [Product] = [
    Product(
        title: "Робототехнический набор для младшего возраста Matatalab PRO Set",
        description: "Полный набор для начинающих",
        price: "18000 ₽",
        imageName: "product1",
        characteristics: ["Производитель": "Matatalab", "Комплектация": "Полный комплект"],
        detailedDescription: "Полный набор для начинающих, включающий всё необходимое для старта.",
        specifications: ["Комплект включает: робот, пульт, зарядное устройство", "Подходит для детей от 6 лет"]
    ),
    Product(
        title: "Расширенный набор Робот+. Уровень 2 (контроллеры Ардуино)",
        description: "Расширенные возможности для профессионалов",
        price: "18000 ₽",
        imageName: "product2",
        characteristics: ["Производитель": "Робот+", "Комплектация": "Расширенный комплект"],
        detailedDescription: """
В состав набора входят компоненты для создания сложных проектов с использованием контроллеров Ардуино. Набор включает различные датчики, моторы и прочие элементы для создания робототехнических систем.
""",
        specifications: [
            "Управляющий блок: 1",
            "Блок питания: 1",
            "Датчики: 5",
            "Моторы: 4",
            "Кабели: 5"
        ]
    )
]

struct ProductView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            Text(product.title)
                .font(.headline)
            Text(product.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack {
                Text(product.price)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button(action: {
                    // Действие для кнопки "Купить"
                }) {
                    Text("Купить")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct ProductListView: View {
    @ObservedObject var viewModel = ProductViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Каталог")
                    .font(.largeTitle)
                    .padding(.top)
                ForEach(viewModel.products) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductView(product: product)
                            .padding(.bottom, 10)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Каталог")
        .onAppear {
                      self.viewModel.fetchProducts()
                  }
    }
}

struct ProductDetailView: View {
    var product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(product.title)
                    .font(.largeTitle)
                
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                
                Text(product.price)
                    .font(.title)
                    .foregroundColor(.primary)
                
                Button(action: {
                    // Действие для кнопки "Оставить заявку"
                }) {
                    Text("Оставить заявку")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Text("Характеристики")
                    .font(.headline)
                ForEach(product.characteristics.sorted(by: >), id: \.key) { key, value in
                    HStack {
                        Text(key)
                            .font(.subheadline)
                        Spacer()
                        Text(value)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text("Описание")
                    .font(.headline)
                Text(product.detailedDescription)
                    .font(.body)
                
                Text("Спецификации")
                    .font(.headline)
                ForEach(product.specifications, id: \.self) { spec in
                    Text("• \(spec)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(product.title)
    }
}
