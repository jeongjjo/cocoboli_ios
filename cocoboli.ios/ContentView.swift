//
//  ContentView.swift
//  cocoboli.ios
//
//  Created by cho.min-su on 2022/03/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView(url: Constants.MAIN_URL)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
