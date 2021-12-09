import SwiftUI

struct PlatformListView: View {
    var name: String
    
    @EnvironmentObject var platformModelController: PlatformModelController
    
    var body: some View {
        List {
            ForEach(platformModelController.data) { platform in
                NavigationLink(destination: PlatformDetailView(platform: platform)) {
                    PlatformView(platform: platform)
                }.disabled(!(platform.active && platform.userCredentialsAvailable))
            }
        }
        .navigationTitle(name)
        .if(platformModelController.isLoading) { view in
            view.overlay(ProgressView())
        }
    }
}
