import SwiftUI

struct PaipanDetailView: View {
	@Environment(\.presentationMode) var presentationMode
	
	var selectedDate: Date
	var selectedLunarDate: String
	var zhuGua: [Bool]
	var dongYao: Int

	@State private var huGua: [Bool] = Array(repeating: false, count: 6)
	@State private var bianGua: [Bool] = Array(repeating: false, count: 6)

	var body: some View {
		ScrollView {
			VStack {
				Text("指定排盘")
					.font(.title)
					.padding()
					.frame(maxWidth: .infinity, alignment: .center)
				
				DateDisplayView(title: "公历", date: DateUtils.dateToString(selectedDate))
				
				DateDisplayView(title: "农历", date: selectedLunarDate)
				
				GanZhiView(selectedDate: selectedDate)
				
				HexagramSectionView(huGua: $huGua, bianGua: $bianGua)
				
				TextInputView(placeholder: "占问 所问之事", text: .constant(""))
				
				TextInputView(placeholder: "反馈 断语，分析", text: .constant(""))
				
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
		.onAppear {
			// Fetch or initialize ganZhiModel data here if needed
		}
	}
}

struct DateDisplayView: View {
	var title: String
	var date: String

	var body: some View {
		HStack {
			Text(title)
			Spacer()
			Text(date)
				.frame(maxWidth: .infinity, alignment: .center)
		}
		.padding()
	}
}

// Model for GanZhi data
class GanZhiModel: ObservableObject {
	
	@Published var nianGanZhi: String = "甲子"
	@Published var yueGanZhi: String = "甲子"
	@Published var riGanZhi: String = "甲子"
	@Published var shiGanZhi: String = "甲子"
	@Published var riKongWang: String = "[戌亥空]"
}

struct GanZhiView: View {
	private var selectedDate: Date // 外部传入的日期
	private var ganZhiModel = GanZhiModel()
	
	init(selectedDate: Date) {
		self.selectedDate = selectedDate
		// 初始化ganZhiModel
		print("Update GanZhiModel...")
		
		// 计算四纲
		var ganzhiStr = DateUtils.SiGangGanZhi(from: selectedDate)
		let components = ganzhiStr.split(separator: " ")
		if components.count == 4 {
			ganZhiModel.nianGanZhi = String(components[0])
			ganZhiModel.yueGanZhi = String(components[1])
			ganZhiModel.riGanZhi = String(components[2])
			ganZhiModel.shiGanZhi = String(components[3])
		}
		
		// 计算日空亡
		var riKongWang = DateUtils.RiKongWang(from: selectedDate)
		ganZhiModel.riKongWang = String(riKongWang)
	}
	var body: some View {
		HStack {
			VStack {
				Text(ganZhiModel.nianGanZhi)
			}
			Spacer()
			VStack {
				Text(ganZhiModel.yueGanZhi)
			}
			Spacer()
			VStack {
				Text(ganZhiModel.riGanZhi)
			}
			Spacer()
			VStack {
				Text(ganZhiModel.shiGanZhi)
			}
			Spacer()
			VStack {
				Text(ganZhiModel.riKongWang)
			}
		}
		.padding()
	}
}


struct HexagramSectionView: View {
	@Binding var huGua: [Bool]
	@Binding var bianGua: [Bool]

	var body: some View {
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

struct TextInputView: View {
	var placeholder: String
	@Binding var text: String

	var body: some View {
		TextField(placeholder, text: $text)
			.padding()
			.background(Color.gray.opacity(0.1))
			.cornerRadius(10)
			.padding(.horizontal)
	}
}

struct PaipanDetailView_Previews: PreviewProvider {
	static var previews: some View {
		PaipanDetailView(selectedDate: Date(), selectedLunarDate: "", zhuGua: [true, true, true, true, true, true], dongYao: 0)
	}
}


