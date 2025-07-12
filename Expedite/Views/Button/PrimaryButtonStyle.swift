struct PrimaryButtonStyle: ButtonStyle {
    @State private var isHovered = false;
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(.black)
            .foregroundStyle(.white)
            .overlay(
                .white.opacity(isHovered ? 0.07 : 0)
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .onHover(perform: {hovering in
                isHovered = hovering
            })
            .cornerRadius(8)
            .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
}