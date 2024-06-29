import SwiftUI

struct MeihuayishuPanSelectionView: View {
	// 主卦的爻的状态
	@State private var zhuGua: [Bool] = Array(repeating: false, count: 6)
	@State private var dongYao = 0
	@State private var showPaipanDetail = false // State to control navigation
		
	
	let yaoLabels = ["初爻", "二爻", "三爻", "四爻", "五爻", "上爻"]
	
	
	var body: some View {
		VStack {
			Text("梅花易数 指定排盘")
				.font(.title)
				.padding()
			
			HStack {
				Text("公历")
				Spacer()
				Text("2024-06-29 22:43")
			}
			.padding()
			
			HStack {
				Text("农历")
				Spacer()
				Text("二〇二四年五月廿四 亥时")
			}
			.padding()
			
			// 主卦状态
			VStack {
				ForEach((0..<6).reversed(), id: \.self) { index in
					HStack {
						Text(yaoLabels[index])
						Spacer()
						Rectangle()
							.fill(Color.black)
							.frame(height: 20)
							.onTapGesture {
								zhuGua[index].toggle()
							}
							.overlay(
								zhuGua[index] ? AnyView(
									HStack {
										Spacer()
										Rectangle()
											.fill(Color.white)
											.frame(width: 10)
										Spacer()
									}
								) : AnyView(EmptyView())
							)
						Spacer()
						Image(systemName: dongYao == index ? "checkmark.square.fill" : "square")
							.foregroundColor(dongYao == index ? .green : .gray)
							.font(.system(size: 20))
							.onTapGesture {
								dongYao = index
							}
					}
					.padding()
				}
			}
			.padding()
			.background(Color.white)
			.cornerRadius(10)
			.shadow(radius: 5)
			.padding()
			
			Spacer()
			
			NavigationLink(destination: PaipanDetailView(), isActive: $showPaipanDetail) {
				Button(action: {
					// Handle the button action
					print("动爻 index: \(dongYao)")
					showPaipanDetail = true // Activate navigation
				}) {
					Text("立即排盘")
						.foregroundColor(.green)
						.padding()
						.frame(maxWidth: .infinity)
						.background(RoundedRectangle(cornerRadius: 10).stroke(Color.green))
						.padding()
				}
			}
		}
		.padding()
	}
}

struct MeihuayishuPan_Previews: PreviewProvider {
	static var previews: some View {
		MeihuayishuPanSelectionView()
	}
}

