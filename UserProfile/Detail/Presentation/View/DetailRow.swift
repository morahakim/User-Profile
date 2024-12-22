//
//  DetailInfoRow.swift
//  UserProfile
//
//  Created by mora hakim on 22/12/24.
//

import SwiftUI

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}
