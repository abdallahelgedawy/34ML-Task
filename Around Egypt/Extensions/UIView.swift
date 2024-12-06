//
//  UIView.swift
//  Around Egypt
//
//  Created by Abdallah Elgedawy on 06/12/2024.
//

import Foundation
import SwiftUI
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}
