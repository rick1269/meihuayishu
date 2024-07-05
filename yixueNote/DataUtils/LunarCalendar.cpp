#include "LunarCalendar.h"
#include "lunarData.hpp"

using namespace baseUtils;

// 获取农历信息
const char* getLunarDate(int year, int month, int day, int hour, int minute){
	lunarData _lunar;
	const char* result = _lunar.getLunarData(year, month, day, hour, minute);
	return result;
}
