import SwiftUI

struct LabelWithIcon: View {
    
    var title: String
    var systemImageName: String
    
    var body: some View {
        HStack {
            Text("\(title):")
            Image(systemName:systemImageName)
                .foregroundColor(.green)
        }
    }
}
