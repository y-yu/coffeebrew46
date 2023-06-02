import SwiftUI
import SwiftUITooltip

struct TipsView: View {
    var showTips: Bool
    var tooltipConfig = DefaultTooltipConfig()
    
    var content: any View
    var tips: Text
    
    let opacity = 0.6
    
    init(_ showTips: Bool, content: any View, tips: Text) {
        self.showTips = showTips
        self.content = content
        self.tips = tips
        
        self.tooltipConfig.borderColor = .primary.opacity(opacity - 0.3)
        self.tooltipConfig.borderRadius = 10
        self.tooltipConfig.enableAnimation = true
        self.tooltipConfig.animationOffset = 5
        self.tooltipConfig.animationTime = 5
        self.tooltipConfig.margin = -30
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                AnyView(content)
                Spacer()
            }
        }
            .padding(.bottom, showTips ? 18 : 0)
            .offset(y: showTips ? 25 : 0)
            .tooltip(showTips, side: .top, config: self.tooltipConfig) {
                tips
                    .font(.system(size: 12).weight(.light))
                    .fixedSize()
                    .foregroundColor(.primary.opacity(opacity))
            }
    }
}

#if DEBUG
struct TipsView_Previews: PreviewProvider {
    @State static var showTips = true
    
    static var previews: some View {
        Form {
            Toggle("show tips", isOn: $showTips)
            TipsView(
                showTips,
                content: HStack {
                    Text("config 1st water percent")
                    Text("100%")
                },
                tips: Text("config 1st water percent help")
            )
        }
    }
}

#endif
