//
//  lunar.hpp
//  yixueNote
//
//  Created by rick qiu on 2024/6/30.
//

#ifndef lunar_hpp
#define lunar_hpp

#include <stdio.h>
#include <string>
#include <vector>

namespace baseUtils {

class lunarData { 
public:
	lunarData();
	~lunarData();
public:
	// 获取农历时间
	const char* getLunarData(int y, int m, int d, int hour, int minute);
	
	// 获取天干地支
	const char* getSiGangGanZhi(int y, int m, int d, int hour, int minute);
	
	// 获取日空亡
	const char* getRiKongWang(int y, int m, int d, int hour, int minute);
	
private:
	int lYearDays(int y);
	int leapMonth(int y);
	int leapDays(int y);
	int monthDays(int y, int m);
	int solarDays(int y, int m);
	std::string toGanZhiYear(int lYear); 
	std::string toGanZhi(int offset);
	int getTerm(int y, int n);
	std::string toChinaMonth(int m);
	std::string toChinaDay(int d);
	std::string getAnimal(int y);
	int getOffsetDays(int start_y, int start_m, int start_d, int y, int m, int d);
	int getShiChen(int hour, int minute);
	// 更新时间信息
	bool updataSolar2lunar(int y, int m, int d, int hour, int minute);
};
} // namespace

#endif /* lunar_hpp */
