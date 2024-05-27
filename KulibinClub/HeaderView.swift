//
//  HeaderView.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import SwiftUI
#Preview {
    HeaderView(sideMenu: .constant(true))
}
struct HeaderView: View {
    @Binding var sideMenu: Bool

    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                sideMenu.toggle()
            }) {
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            Image(.logo2)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 44)
            Spacer()
        }.blur(radius: sideMenu ? 10 : 0)
        .padding()
        .frame(height: 55)
        .transaction { transaction in
            transaction.animation = .spring(.smooth)
            transaction.disablesAnimations = true
            transaction.isContinuous = true
        }
        .background(.clear)
    }
}
