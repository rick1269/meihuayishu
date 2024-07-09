import SwiftUI

struct PaipanHistoryView: View {
	var body: some View {
		List {
			ForEach(dummyData) { example in
				NavigationLink(destination: Text("Detail View")) { // 替换为详细视图
					GuaExampleView(mainGuaName: example.mainGuaName,
								   changingGuaName: example.changingGuaName,
								   time: example.time,
								   question: example.question)
				}
			}
		}
		.navigationTitle("卦例笔记")
	}
	
	// Dummy data for demonstration
	let dummyData = [
		GuaExample(mainGuaName: "乾", changingGuaName: "坤", time: Date(), question: "关于事业发展的问题"),
		GuaExample(mainGuaName: "坤", changingGuaName: "乾", time: Date(), question: "感情状况的咨询"),
		GuaExample(mainGuaName: "震", changingGuaName: "坎", time: Date(), question: "家庭和谐的困扰"),
	]
}

struct GuaExample: Identifiable {
	var id = UUID()
	var mainGuaName: String
	var changingGuaName: String
	var time: Date
	var question: String
}



struct GuaExampleView: View {
	var mainGuaName: String
	var changingGuaName: String
	var time: Date
	var question: String
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("\(mainGuaName) 之 \(changingGuaName)")
				.font(.headline)
				.lineLimit(1)
				.padding(.bottom, 4)
			
			Text("\(time, formatter: dateFormatter)")
				.font(.caption)
				.foregroundColor(.gray)
				.lineLimit(1)
			
			Text("\(question)")
				.font(.subheadline)
				.foregroundColor(.gray)
				.lineLimit(2)
				.truncationMode(.tail)
		}
		.padding()
		.background(Color(UIColor.systemGray6))
		.cornerRadius(10)
		.shadow(radius: 5)
		.padding(.horizontal)
		.padding(.vertical, 4)
	}
	
	private var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}
}
