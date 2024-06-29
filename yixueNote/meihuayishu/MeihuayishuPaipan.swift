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

struct CustomDatePicker: View {
	@Binding var selectedDate: Date
	@Binding var showDatePicker: Bool

	let years = Array(1900...2100)
	let months = Array(1...12)
	let days = Array(1...31)
	let hours = Array(0...23)
	let minutes = Array(0...59)
	
	@State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
	@State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
	@State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
	@State private var selectedHour: Int = Calendar.current.component(.hour, from: Date())
	@State private var selectedMinute: Int = Calendar.current.component(.minute, from: Date())

	var body: some View {
		VStack {
			HStack {
				Button("取消") {
					showDatePicker = false
				}
				Spacer()
				Button("确认") {
					let components = DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay, hour: selectedHour, minute: selectedMinute)
					if let newDate = Calendar.current.date(from: components) {
						selectedDate = newDate
					}
					showDatePicker = false
				}
			}
			.padding()

			HStack(spacing: 0) {
				Picker("Year", selection: $selectedYear) {
					ForEach(years, id: \.self) { year in
						Text("\(year)").tag(year)
							.font(.system(size: 15))
					}
				}
				.frame(maxWidth: .infinity)
				.clipped()
				Picker("Month", selection: $selectedMonth) {
					ForEach(months, id: \.self) { month in
						Text(String(format: "%02d", month)).tag(month)
							.font(.system(size: 15))
					}
				}
				.frame(maxWidth: .infinity)
				.clipped()
				Picker("Day", selection: $selectedDay) {
					ForEach(days, id: \.self) { day in
						Text(String(format: "%02d", day)).tag(day)
							.font(.system(size: 15))
					}
				}
				.frame(maxWidth: .infinity)
				.clipped()
				Picker("Hour", selection: $selectedHour) {
					ForEach(hours, id: \.self) { hour in
						Text(String(format: "%02d", hour)).tag(hour)
							.font(.system(size: 15))
					}
				}
				.frame(maxWidth: .infinity)
				.clipped()
				Picker("Minute", selection: $selectedMinute) {
					ForEach(minutes, id: \.self) { minute in
						Text(String(format: "%02d", minute)).tag(minute)
							.font(.system(size: 15))
					}
				}
				.frame(maxWidth: .infinity)
				.clipped()
			}
			.pickerStyle(WheelPickerStyle())
			.frame(maxWidth: .infinity)
			.clipped()
			.background(Color.white)
			.cornerRadius(10)
			.shadow(radius: 5)
		}
		.padding()
	}
}
