//
//  LazyView.swift
//  DogGram
//
//  Created by Man Yuan on 04/06/2021.
//

import Foundation
import SwiftUI

struct lazyView<Content: View>: View {
    
    var content: () -> Content
    
    var body: some View {
        self.content()
    }
}
