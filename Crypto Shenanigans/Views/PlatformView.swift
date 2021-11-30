import SwiftUI

struct PlatformView: View {
    var platform: Platform
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(platform.description)
                .font(.headline)
            Spacer()
            HStack {
                PlatformStatus(text: "Active", status: platform.active)
                Spacer()
                PlatformStatus(text: "Credentials Stored", status: platform.userCredentialsAvailable)
            }
        }
        .padding()
    }
}

struct PlatformView_Preview: PreviewProvider {
    static var platform = Platform(active: true, description: "Dummy Name", id: "1", platformUserId: 1, userCredentialsAvailable: false)
    static var previews: some View {
        PlatformView(platform: platform)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
