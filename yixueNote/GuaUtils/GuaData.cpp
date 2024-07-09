//
//  GuaData.cpp
//  yixueNote
//
//  Created by rick qiu on 2024/7/8.
//

#include "GuaData.hpp"

namespace baseUtils {

GuaData::GuaData(/* args */)
{
}

GuaData::~GuaData()
{
}

// 获取卦的名字
std::string GuaData::getGuaName(int guaIndex){
	// 检查卦序号的有效性
	if (guaIndex < 0 || guaIndex >= 64) {
		return "无效的卦序号";
	}
	return GuaFangYuanTu[guaIndex];
}

// 获取阴阳爻信息（最低位为初爻）
std::string GuaData::getYinYangYao(int guaIndex){
	std::string yinYangYao = "";
	// 检查卦序号的有效性
	if (guaIndex < 0 || guaIndex >= 64) {
		return "无效的卦序号";
	}
	// 通过位运算获取阴阳爻信息
	for (int i = 0; i < 6; ++i) {
		if (guaIndex & (1 << i)) {
			yinYangYao = "1" + yinYangYao; // 爻为阳
		} else {
			yinYangYao = "0" + yinYangYao; // 爻为阴
		}
	}
	
	return yinYangYao;
}

} // namespace baseUtils
