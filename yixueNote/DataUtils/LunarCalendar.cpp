#include "LunarCalendar.h"
#include "lunarData.hpp"

using namespace baseUtils;

const char* convertToLunarDate(int year, int month, int day, int hour, int minute){
	static std::string result = "时间计算错误，请重启应用重试！";
	
	lunarData _lunar;
	
	bool res = _lunar.updataSolar2lunar(year, month, day, hour, minute);
	if(res){
		DataStruct _data = _lunar.getData(); 
		result = std::to_string(_data.lYear) + "年" + std::to_string(_data.lMonth) + "月" + std::to_string(_data.lDay) + "日";
	}

	return result.c_str();
}
