import SwiftUI

struct MeihuayishuPanSelectionView: View {
	// 主卦的爻的状态
	@State private var zhuGua: [Bool] = Array(repeating: false, count: 6)
	@State private var dongYao = 0
	@State private var showPaipanDetail = false // 控制导航的状态
	@State private var showDatePicker = false // 控制日期选择器显示与否的状态
	@State private var selectedDate = Date() // 保存选定日期的状态
	
	let yaoLabels = ["初爻", "二爻", "三爻", "四爻", "五爻", "上爻"]
	
	var body: some View {
		ZStack {
			VStack {
				Text("梅花易数 指定排盘")
					.font(.title)
					.padding()
				
				VStack {
					HStack {
						Text("公历")
							.frame(alignment: .leading)
						Spacer()
						Text(DateUtils.dateToString(selectedDate))
							.onTapGesture {
								showDatePicker.toggle()
							}
							.frame(maxWidth: .infinity, alignment: .center)
					}
					.padding()
					
					HStack {
						Text("农历")
						Spacer()
						Text(DateUtils.lunarDate(from: selectedDate))
							.frame(maxWidth: .infinity, alignment: .center) // 让文本居中对齐
					}
					.padding()
				}
				.padding()
				.background(Color.white)
				.cornerRadius(10)
				.shadow(radius: 5)
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
						// 处理按钮点击事件
						print("动爻 index: \(dongYao)")
						showPaipanDetail = true // 激活导航
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
			
			if showDatePicker {
				Color.black.opacity(0.3)
					.edgesIgnoringSafeArea(.all)
					.onTapGesture {
						showDatePicker = false
					}
				
				CustomDatePicker(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
					.frame(maxWidth: .infinity)
					.clipped()
					.background(Color.white)
					.cornerRadius(10)
					.shadow(radius: 5)
					.padding()
			}
		}
	}
}

struct MeihuayishuPan_Previews: PreviewProvider {
	static var previews: some View {
		MeihuayishuPanSelectionView()
	}
}

