import SwiftUI

struct TimeSelectionView: View {
	@State private var yValues: [Bool] = Array(repeating: false, count: 6)
	
	var body: some View {
		VStack {
			Text("指定排盘")
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
			
			ForEach(0..<6) { index in
				HStack {
					Text("\(6 - index)爻")
					Spacer()
					Rectangle()
						.fill(Color.brown)
						.frame(height: 20)
						.onTapGesture {
							yValues[index].toggle()
						}
						.overlay(
							yValues[index] ? AnyView(
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
					Text(yValues[index] ? "动" : "静")
						.foregroundColor(yValues[index] ? .green : .gray)
				}
				.padding()
			}
			
			Spacer()
			
			Button(action: {
				// Handle the button action
			}) {
				Text("立即排盘")
					.foregroundColor(.green)
					.padding()
					.frame(maxWidth: .infinity)
					.background(RoundedRectangle(cornerRadius: 10).stroke(Color.green))
					.padding()
			}
		}
		.padding()
	}
}

struct ZhidingPaipan_Previews: PreviewProvider {
	static var previews: some View {
		TimeSelectionView()
	}
}

