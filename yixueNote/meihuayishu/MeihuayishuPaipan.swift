import SwiftUI

struct MeihuayishuPanSelectionView: View {
	@State private var zhuGuaXu = 63
	@State private var dongYao = 0
	@State private var showPaipanDetail = false
	@State private var showDatePicker = false
	@State private var selectedDate = Date()
	@State private var selectedLunarDate = String()
	
	var body: some View {
		ZStack {
			VStack {
				Text("梅花易数 指定排盘")
					.font(.title)
					.padding()
				
				// 日期选择模块
				DatePickerSection(selectedDate: $selectedDate, selectedLunarDate: $selectedLunarDate, showDatePicker: $showDatePicker)

				// 主卦状态模块
				ZhuGuaView(zhuGuaXu: $zhuGuaXu, dongYao: $dongYao)
								
				Spacer()
				
				// 排盘细节界面入口模块
				PaipanNavigationLink(
									showPaipanDetail: $showPaipanDetail,
									selectedDate: selectedDate,
									selectedLunarDate: selectedLunarDate,
									zhuGuaXu: zhuGuaXu,
									dongYao: dongYao
								)
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
		.onDisappear {
			UserDefaultsManager.clearSelectedDate()
		}
	}
}


/// 时间选择模块
struct DatePickerSection: View {
	@Binding var selectedDate: Date
	@Binding var selectedLunarDate: String
	@Binding var showDatePicker: Bool
	
	var body: some View {
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
					.onAppear {
						updateLunarDate() // 初始加载时更新农历日期
					}
					.onChange(of: selectedDate) { _ in
						updateLunarDate() // 公历日期变化时更新农历日期
					}
			}
			.padding()
			
			HStack {
				Text("农历")
				Spacer()
				Text(selectedLunarDate)
					.frame(maxWidth: .infinity, alignment: .center)
			}
			.padding()
		}
		.padding()
		.background(Color.white)
		.cornerRadius(10)
		.shadow(radius: 5)
		.padding()
	}
	
	private func updateLunarDate() {
		selectedLunarDate = DateUtils.lunarDate(from: selectedDate)
		print("DatePickerSection 农历日期: \(selectedLunarDate)")
	}
}


/// 自定义时间表
struct UserDefaultsManager {
	static let selectedDateKey = "selectedDateKey"
	
	static func saveSelectedDate(_ date: Date) {
		UserDefaults.standard.set(date, forKey: selectedDateKey)
	}
	
	static func retrieveSelectedDate() -> Date? {
		return UserDefaults.standard.object(forKey: selectedDateKey) as? Date
	}
	
	static func clearSelectedDate() {
		UserDefaults.standard.removeObject(forKey: selectedDateKey)
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
	
	@State private var selectedYear: Int
	@State private var selectedMonth: Int
	@State private var selectedDay: Int
	@State private var selectedHour: Int
	@State private var selectedMinute: Int
	
	init(selectedDate: Binding<Date>, showDatePicker: Binding<Bool>) {
		self._selectedDate = selectedDate
		self._showDatePicker = showDatePicker
		
		if let lastSelectedDate = UserDefaultsManager.retrieveSelectedDate() {
			let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: lastSelectedDate)
			self._selectedYear = State(initialValue: dateComponents.year ?? Calendar.current.component(.year, from: Date()))
			self._selectedMonth = State(initialValue: dateComponents.month ?? Calendar.current.component(.month, from: Date()))
			self._selectedDay = State(initialValue: dateComponents.day ?? Calendar.current.component(.day, from: Date()))
			self._selectedHour = State(initialValue: dateComponents.hour ?? Calendar.current.component(.hour, from: Date()))
			self._selectedMinute = State(initialValue: dateComponents.minute ?? Calendar.current.component(.minute, from: Date()))
		} else {
			let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
			self._selectedYear = State(initialValue: dateComponents.year ?? Calendar.current.component(.year, from: Date()))
			self._selectedMonth = State(initialValue: dateComponents.month ?? Calendar.current.component(.month, from: Date()))
			self._selectedDay = State(initialValue: dateComponents.day ?? Calendar.current.component(.day, from: Date()))
			self._selectedHour = State(initialValue: dateComponents.hour ?? Calendar.current.component(.hour, from: Date()))
			self._selectedMinute = State(initialValue: dateComponents.minute ?? Calendar.current.component(.minute, from: Date()))
		}
	}
	
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
						UserDefaultsManager.saveSelectedDate(newDate) // Save the selected date
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
		.onAppear {
			// Clear selected date when appearing if needed (reset to current time)
			UserDefaultsManager.clearSelectedDate()
		}
	}
}

/// 主卦视图模块
struct ZhuGuaView: View {
	@Binding var zhuGuaXu: Int
	@Binding var dongYao: Int
	
	@State private var zhuGua: [Bool] = Array(repeating: false, count: 6)
	
	let yaoLabels = ["初爻", "二爻", "三爻", "四爻", "五爻", "上爻"]
	
	var body: some View {
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
							!zhuGua[index] ? AnyView(
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
		.onAppear(){
			// 将zhuGuaXu转化为二进制，低6位转化为string存入数组
			var binaryString = String(zhuGuaXu, radix: 2)
			binaryString = String(repeating: "0", count: 6 - binaryString.count) + binaryString
//			print("ZhuGuaView 二进制字符串: \(binaryString)")
			
			for (index, char) in binaryString.enumerated() {
				zhuGua[index] = char == "1" ? true : false
			}
		}
		.onChange(of: zhuGua){ _ in
			updateZhuGuaXu()
		}
		
	}
	
	// 函数
	private func updateZhuGuaXu() {
		var xu = 0
		for (i, isSelected) in zhuGua.enumerated() {
			if isSelected {
				xu += 1 << (5 - i)
			}
		}
		zhuGuaXu = xu
//		print("Updated zhuGuaXu to \(zhuGuaXu)")
	}
}


/// 排盘细节入口模块
struct PaipanNavigationLink: View {
	@Binding var showPaipanDetail: Bool
	var selectedDate: Date
	var selectedLunarDate: String
	var zhuGuaXu: Int
	var dongYao: Int
	
	var body: some View {
		NavigationLink(
			destination: PaipanDetailView(selectedDate: selectedDate, selectedLunarDate: selectedLunarDate, zhuGuaXu: zhuGuaXu, dongYao: dongYao),
			isActive: $showPaipanDetail
		) {
			Button(action: {
				print("动爻 index: \(dongYao)")
				showPaipanDetail = true
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
}
