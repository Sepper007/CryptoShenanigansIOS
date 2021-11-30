import SwiftUI

struct PlatformStatus: View {
    var text: String
    var status: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            Text("\(self.text):")
                .font(.system(size: 13))
            Image(systemName:"circle.fill")
                .font(.system(size: 10))
                .foregroundColor(self.status ? .green : .red)
        }
    }
}

struct PlatformStatus_Preview: PreviewProvider {
    static var previews: some View {
        PlatformStatus(text: "Test", status: false)
    }
}
