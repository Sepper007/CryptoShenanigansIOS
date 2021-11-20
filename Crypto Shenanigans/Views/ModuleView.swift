import SwiftUI

struct ModuleView: View {
    let module: Module
    var body: some View {
        VStack(alignment: .center) {
            Text(module.title)
                .font(.headline)
            HStack {
                Text(module.description)
                    .multilineTextAlignment(.center)
                Spacer()
                Image(systemName:module.icon)
                    .font(.system(size: 22))
            }
            .font(.caption)
        }
        .foregroundColor(Color.gray)
    }
}

struct ModuleView_Preview: PreviewProvider {
    static var module = Module.data[0]
    static var previews: some View {
        ModuleView(module: module)
            .background(Color.black)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

