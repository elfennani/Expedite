struct DeviceCard: View {
    let device: Device
    
    init(device: Device) {
        self.device = device
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 4){
                Text(device.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(device.model)
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {}){
                Label("Select", systemImage: "checkmark").padding(6)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(12)
        .transition(
            .asymmetric(
                insertion: .offset(x: -30).combined(with: .opacity),
                removal: .offset(x: 30).combined(with: .opacity)
            ).animation(.easeOut(duration: 0.20))
        )
    }
}