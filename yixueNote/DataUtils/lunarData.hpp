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

typedef struct DataStruct
{
	int cYear; // 公历年
	int cMonth; // 公历月
	int cDay; // 公历日
	int cHour; // 公历时
	int cMinute; // 公历分

	int lYear; // 阴历年
	int lMonth; // 阴历月
	int lDay; // 阴历日

	std::string gzYear; // 干支年
	std::string gzMonth; // 干支月
	std::string gzDay; // 干支日

	std::string Animal; // 生肖
	std::string IMonthCn; // 阴历月中文
	std::string IDayCn; // 阴历日中文

	int isLeap; // 是否是闰月
	int leap; // 闰月是哪个月

	int isTerm; // 是否是节气
	std::string Term; // 节气中文

	int nWeek; // 星期几
	std::string cWeek; // 星期几中文

	int isToday; // 是否是今天
	
	DataStruct() {
		reset();
	}

	void reset() {
		cYear = 0;
		cMonth = 0;
		cDay = 0;
		cHour = 0;
		cMinute = 0;

		lYear = 0;
		lMonth = 0;
		lDay = 0;

		gzYear = "";
		gzMonth = "";
		gzDay = "";

		Animal = "";
		IMonthCn = "";
		IDayCn = "";

		isLeap = 0;
		leap = 0;

		isTerm = 0;
		Term = "";

		nWeek = 0;
		cWeek = "";
		
		isToday = 0; 

	}
}DataStruct;


class lunarData { 
public:
	lunarData();
	~lunarData();
public:
	// 更新时间信息
	bool updataSolar2lunar(int y, int m, int d, int hour, int minute);

	// 获取农历时间
	const char* getLunarData(int y, int m, int d, int hour, int minute);
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
	
private:
	
};
} // namespace

#endif /* lunar_hpp */
