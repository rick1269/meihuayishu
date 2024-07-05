import SwiftUI

struct PaipanDetailView: View {
	@Environment(\.presentationMode) var presentationMode // 获取当前视图的呈现模式
	
	var selectedDate: Date // 接收从梅花易数界面传递过来的公历时间
	
	var body: some View {
		ScrollView {
			VStack {
				Text("指定排盘")
					.font(.title)
					.padding()
					.frame(maxWidth: .infinity, alignment: .center)
				
				HStack {
					Text("公历")
					Spacer()
					Text(DateUtils.dateToString(selectedDate))
						.frame(maxWidth: .infinity, alignment: .center)
				}
				.padding()
				
				HStack {
					Text("农历")
					Spacer()
					Text("二〇二四年五月廿四 亥时")
						.frame(maxWidth: .infinity, alignment: .center)
				}
				.padding()
				
				HStack {
					VStack {
						Text("甲")
						Text("辰")
					}
					Spacer()
					VStack {
						Text("康")
						Text("午")
					}
					Spacer()
					VStack {
						Text("甲")
						Text("子")
					}
					Spacer()
					VStack {
						Text("乙")
						Text("亥")
					}
					Spacer()
					Text("[戌亥空]")
				}
				.padding()
				
				HStack {
					VStack {
						Text("[主]")
							.foregroundColor(.gray)
						HexagramView()
						Text("风火家人")
					}
					Spacer()
					VStack {
						Text("[互]")
							.foregroundColor(.gray)
						HexagramView()
						Text("火水未济")
					}
					Spacer()
					VStack {
						Text("[变]")
							.foregroundColor(.gray)
						HexagramView()
						Text("风山渐")
					}
				}
				.padding()
				
				TextField("占问 所问之事", text: .constant(""))
					.padding()
					.background(Color.gray.opacity(0.1))
					.cornerRadius(10)
					.padding(.horizontal)
				
				TextField("反馈 断语，分析", text: .constant(""))
					.padding()
					.background(Color.gray.opacity(0.1))
					.cornerRadius(10)
					.padding(.horizontal)
				
				Spacer()
				
				HStack {
					Spacer()
					Button(action: {
						// Save to cloud action
					}) {
						Image(systemName: "plus")
							.resizable()
							.frame(width: 50, height: 50)
							.foregroundColor(.green)
							.background(Color.white)
							.clipShape(Circle())
							.shadow(radius: 5)
					}
				}
				.padding()
			}
			.padding()
		}
	}
}


struct HexagramView: View {
	var body: some View {
		VStack(spacing: 2) {
			ForEach(0..<6) { _ in
				HStack {
					Rectangle()
						.fill(Color.black)
						.frame(height: 20)
				}
			}
		}
	}
}

struct PaipanDetailView_Previews: PreviewProvider {
	static var previews: some View {
		PaipanDetailView(selectedDate: Date())
	}
}

