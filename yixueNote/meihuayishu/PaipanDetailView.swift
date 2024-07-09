import SwiftUI

struct PaipanDetailView: View {
	@Environment(\.presentationMode) var presentationMode
	
	var selectedDate: Date
	var selectedLunarDate: String
	var zhuGuaXu: Int
	var dongYao: Int

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
				
				HexagramSectionView(zhuGuaXu: zhuGuaXu, dongYao: dongYao)
							   
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
	var zhuGuaXu: Int
	var dongYao: Int
	private var zhuGua: [Bool]
	private var huGua: [Bool]
	private var bianGua: [Bool]
	
	init(zhuGuaXu: Int, dongYao: Int) {
		self.zhuGuaXu = zhuGuaXu
		self.dongYao = dongYao
		self.zhuGua = [Bool](repeating: false, count: 6)
		self.huGua = [Bool](repeating: false, count: 6)
		self.bianGua = [Bool](repeating: false, count: 6)
		
		var binaryString = String(zhuGuaXu, radix: 2)
		binaryString = String(repeating: "0", count: 6 - binaryString.count) + binaryString
		
		for (index, char) in binaryString.enumerated() {
			self.zhuGua[index] = char == "1" ? true : false
		}
		
		// 定义主卦中每个位置对应的互卦位置关系
		let mapping = [1, 2, 3, 2, 3, 4]
		
		for (index, value) in mapping.enumerated() {
			self.huGua[index] = self.zhuGua[value - 1]
		}
		
		// 根据动爻计算变卦
		self.bianGua = zhuGua
		self.bianGua[dongYao] = !self.bianGua[dongYao]
	}
	
	var body: some View {
		VStack(spacing: 20) {
			HStack(spacing: 10) {
				VStack {
					Text("[主]")
						.foregroundColor(.gray)
					ZhuGuaHexagramView(zhuGua: zhuGua, dongYao: dongYao)
					Text("雷水解")
				}
				Spacer()
				
				VStack {
					Text("[互]")
						.foregroundColor(.gray)
					HexagramView(Gua: huGua)
					Text("水火既济")
				}
				
				Spacer()
				
				VStack {
					Text("[变]")
						.foregroundColor(.gray)
					HexagramView(Gua: bianGua)
					Text("雷地豫")
				}
			}
			.padding()
		}
	}
}

struct ZhuGuaHexagramView: View {
	var zhuGua: [Bool]
	var dongYao: Int
	
	var body: some View {
		VStack(spacing: 6) {
			ForEach((0..<6).reversed(), id: \.self) { index in
				HStack {
					VStack{
						Rectangle()
							.fill(Color.black)
							.frame(height: 6)
							.frame(width:80)
							.overlay(
								!self.zhuGua[index] ? AnyView(
									HStack {
										Spacer()
										Rectangle()
											.fill(Color.white)
											.frame(width: 5)
										Spacer()
									}
								) : AnyView(EmptyView())
							)
					}
					
					Spacer()
					
					VStack{
						Image(systemName: "circle")
							.foregroundColor(dongYao == index ? .red : .white)
							.font(.system(size: 4))
					}
					
					
				}
				.padding(.vertical, 5)
			}
		}
	}
}

struct HexagramView: View {
	var Gua: [Bool]
	
	var body: some View {
		VStack(spacing: 6) {
			ForEach((0..<6).reversed(), id: \.self) { index in
				HStack {
					Rectangle()
						.fill(Color.black)
						.frame(height: 6)
						.frame(width:80)
						.overlay(
							!self.Gua[index] ? AnyView(
								HStack {
									Spacer()
									Rectangle()
										.fill(Color.white)
										.frame(width: 5)
									Spacer()
								}
							) : AnyView(EmptyView())
						)
					Spacer()
						.frame(width: 10) // 这里指定空白区域的宽度
				}
				.padding(.vertical, 5)
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
		PaipanDetailView(selectedDate: Date(), selectedLunarDate: "", zhuGuaXu: 0, dongYao: 0)
	}
}


