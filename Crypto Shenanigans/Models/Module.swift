import SwiftUI

struct Module: Identifiable {
    var id: Int
    var title: String
    var description: String
    var icon: String
}

extension Module {
    static var data: [Module] {
        [
            Module(id: 1, title:"Analytics", description: "Review your current crypto holdings an get a detailed profit and loss overview", icon: "chart.xyaxis.line"),
            Module(id: 2, title: "Bot Trading", description: "Start and manage fully automated trading bots",icon: "appletvremote.gen3")
        ]
    }
}
