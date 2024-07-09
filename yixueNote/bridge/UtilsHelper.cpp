#include "UtilsHelper.h"
#include "lunarData.hpp"
#include "GuaData.hpp"
 
// 获取农历信息
const char* getLunarDate(int year, int month, int day, int hour, int minute){
	baseUtils::lunarData _lunar;
	const char* result = _lunar.getLunarData(year, month, day, hour, minute);
	return result;
}

// 获取四纲信息
const char* getSiGangGanZhi(int year, int month, int day, int hour, int minute){
	baseUtils::lunarData _lunar;
	const char* result = _lunar.getSiGangGanZhi(year, month, day, hour, minute);
	return result;
}

// 获取空亡信息
const char* getRiKongWang(int year, int month, int day, int hour, int minute){
	baseUtils::lunarData _lunar;
	const char* result = _lunar.getRiKongWang(year, month, day, hour, minute);
	return result;
}

// 获取卦名字
const char* getGuaName(int GuaXu){
	baseUtils::GuaData _guaData;
	std::string str = _guaData.getGuaName(GuaXu);
	
	const int bufferSize = 100;
	char* buffer = (char*)malloc(bufferSize * sizeof(char));
	if (buffer == nullptr) {
		printf("内存分配失败\n");
		return ""; // 返回空字符串表示错误
	}
	
	// 构造农历时间字符串
	sprintf(buffer, "%s", str.c_str());
	
//	printf("%s\n", buffer);  // 输出空亡信息
	
	return buffer;
}

// 获取卦阴阳爻信息
const char* getGuaYinYangYao(int GuaXu){
	baseUtils::GuaData _guaData;
	std::string str = _guaData.getYinYangYao(GuaXu);
	
	const int bufferSize = 100;
	char* buffer = (char*)malloc(bufferSize * sizeof(char));
	if (buffer == nullptr) {
		printf("内存分配失败\n");
		return ""; // 返回空字符串表示错误
	}
	
	// 构造农历时间字符串
	sprintf(buffer, "%s", str.c_str());
	
//	printf("%s\n", buffer);  // 输出空亡信息
	
	return buffer;
}
