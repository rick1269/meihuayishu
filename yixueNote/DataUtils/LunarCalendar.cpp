#include "LunarCalendar.h"
#include "lunarData.hpp"

using namespace baseUtils;

// 获取农历信息
const char* getLunarDate(int year, int month, int day, int hour, int minute){
	lunarData _lunar;
	const char* result = _lunar.getLunarData(year, month, day, hour, minute);
	return result;
}

// 获取四纲信息
const char* getSiGangGanZhi(int year, int month, int day, int hour, int minute){
	lunarData _lunar;
	const char* result = _lunar.getSiGangGanZhi(year, month, day, hour, minute);
	return result;
}

// 获取空亡信息
const char* getRiKongWang(int year, int month, int day, int hour, int minute){
	lunarData _lunar;
	const char* result = _lunar.getRiKongWang(year, month, day, hour, minute);
	return result;
}
