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

namespace baseUtils {

struct lunar
{
	int year, month, day; // 年月日
	bool isLeap; //是否为闰月，即阴历一年中多月的那一个月
	lunar() {}
	lunar(int y, int m, int d, bool isL): year(y), month(m), day(d), isLeap(isL){};
};

class lunarData {
public:
	lunarData();
	~lunarData();
public:
	// 获取阴历时间
	std::string getLunarString(int year, int month, int day, int hour, int minute);
	
private:
	lunar getLunar(int y, int m, int d);
	
};
} // namespace

#endif /* lunar_hpp */
