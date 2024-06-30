#include "LunarCalendar.h"
#include "lunarData.hpp"

using namespace baseUtils;

const char* convertToLunarDate(int year, int month, int day, int hour, int minute){
	static std::string result = "2024年 五月廿五 亥时";
	
	lunarData _lunar;
	
	result = _lunar.getLunarString(year, month, day, hour, minute);
	
	return result.c_str();
}
