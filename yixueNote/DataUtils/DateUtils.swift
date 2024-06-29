import SwiftUI

class DateUtils {
	static func dateToString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy年 MM月 dd日 HH:mm"
		return formatter.string(from: date)
	}

	static func lunarDate(from date: Date) -> String {
		// 农历日期转换的占位符，可以根据实际需求实现
		return "二〇二四年五月廿四 亥时"
	}
}


// 自定义的时间表
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

