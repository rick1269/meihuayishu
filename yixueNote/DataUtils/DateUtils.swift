import SwiftUI

struct LunarDateSwift {
	var cYear: Int // 公历年
	var cMonth: Int // 公历月
	var cDay: Int // 公历日
	var cHour: Int // 公历时
	var cMinute: Int // 公历分
	
	var lYear: Int // 阴历年
	var lMonth: Int // 阴历月
	var lDay: Int // 阴历日
	
	var gzYear: String // 干支年
	var gzMonth: String // 干支月
	var gzDay: String // 干支日
	
	var animal: String // 生肖
	var iMonthCn: String // 阴历月中文
	var iDayCn: String // 阴历日中文
	
	var isLeap: Int // 是否是闰月
	var leap: Int // 闰月是哪个月
	
	var isTerm: Int // 是否是节气
	var term: String // 节气中文
	
	var nWeek: Int // 星期几
	var cWeek: String // 星期几中文
	
	var isToday: Int // 是否是今天
}


class DateUtils {
	static func dateToString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy年 MM月 dd日 HH:mm"
		return formatter.string(from: date)
	}

	static func lunarDate(from date: Date) -> String {
		// 获取日期组件
		let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
		guard let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minute = components.minute else {
			return "Invalid date"
		}
//		print("year: \(year), month: \(month), day: \(day), hour: \(hour), minute: \(minute)")
		
		// 调用C++函数获取农历日期
		guard let lunarDateCStr = getLunarDate(Int32(year), Int32(month), Int32(day), Int32(hour), Int32(minute)) else {
			return "Conversion failed"
		} 
		defer {
			free(UnsafeMutablePointer(mutating: lunarDateCStr))
		}
		let lunarDateStr = String(cString: lunarDateCStr)
		
//		print(" lunarDate : \(lunarDateStr)")
		return lunarDateStr
	}
}


// 自定义时间表
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


