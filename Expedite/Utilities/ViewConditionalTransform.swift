//
//  ViewConditionalTransform.swift
//  Expedite
//
//  Created by Nizar Elfennani on 12/7/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
