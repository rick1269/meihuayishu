//
//  lunar.cpp
//  yixueNote
//
//  Created by rick qiu on 2024/6/30.
//

#include "lunarData.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <ctime>
#include <cmath>
#include <map>
/*
太阳公转周期，一年时间约365.2425天。
公历为了对齐公转周期，4年一闰，100年一停闰，400年加一闰。 400年共97闰， （365×400+97）/400 = 365.2425
农历，一个月相周期为一月，月相周期大约为29.53,   有大小月之分，大月30天，小月29天。
农历为了对齐公转周期，每19年加7个闰月，
因为，农历的推算比较复杂， 大多使用查表法进行计算.
*/

namespace baseUtils {
/** 农历查询表
 1-4 位（从低到高）: 表示当年有无闰年，有的话，为闰月的月份，没有的话，为0。
 5-16 位：为除了闰月外的正常月份是大月还是小月，1为30天，0为29天。
 注意：从 1 月到 12 月对应的是第 16 位到第 5 位（而不是从第 5 位 到第 16 位）。
 17-20 位： 1 和 0 分别表示闰月是 大月 还是 小月，大月 30 天，小月 29 天（仅当存在闰月的情况下有意义）。
 */
std::array<unsigned int, 201> lunarInfo = {
	0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950,
	0x16554, 0x056a0, 0x09ad0, 0x055d2,//1900-1909
	0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977,//1910-1919
	0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,//1920-1929
	0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,//1930-1939
	0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557,//1940-1949
	0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5b0, 0x14573, 0x052b0, 0x0a9a8, 0x0e950, 0x06aa0,//1950-1959
	0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,//1960-1969
	0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b6a0, 0x195a6,//1970-1979
	0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,//1980-1989
	0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0,//1990-1999
	0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,//2000-2009
	0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,//2010-2019
	0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,//2020-2029
	0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,//2030-2039
	0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0,//2040-2049
	0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6, 0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0,//2050-2059
	0x0a2e0, 0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0, 0x0da50, 0x05d55, 0x056a0, 0x0a6d0, 0x055d4,//2060-2069
	0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6, 0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0,//2070-2079
	0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55, 0x04b60, 0x0a570, 0x054e4, 0x0d160,//2080-2089
	0x0e968, 0x0d520, 0x0daa0, 0x16aa6, 0x056d0, 0x04ae0, 0x0a9d4, 0x0a2d0, 0x0d150, 0x0f252,//2090-2099
	0x0d520 //2100
};

/**
 * @brief 公历天数速查表
 */
std::array<int, 12> solarMonth = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

/**
 * @brief 天干地支之天干速查表
 * @Array Of Property
 * @trans["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
 */
std::array<std::string, 10> Gan = {"\u7532","\u4e59","\u4e19","\u4e01","\u620a","\u5df1","\u5e9a","\u8f9b","\u58ec","\u7678"};
/**
 * @brief 天干地支之地支速查表
 * @Array Of Property
 * @trans["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
 */
std::array<std::string, 12> Zhi = {"\u5b50","\u4e11","\u5bc5","\u536f","\u8fb0","\u5df3","\u5348","\u672a","\u7533","\u9149","\u620c","\u4ea5"};

/**
 * @brief 天干地支之地支速查表<=>生肖
 * @Array Of Property
 * @trans["鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"]
 */
std::array<std::string, 12> Animals = {"\u9f20","\u725b","\u864e","\u5154","\u9f99","\u86c7","\u9a6c","\u7f8a","\u7334","\u9e21","\u72d7","\u732a"};

/**
 * @brief 24节气速查表
 * @Array Of Property
 *@trans["小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至"]
 */
std::array<std::string, 24> solarTerm = {"\u5c0f\u5bd2","\u5927\u5bd2","\u7acb\u6625","\u96e8\u6c34","\u60ca\u86f0","\u6625\u5206","\u6e05\u660e","\u8c37\u96e8","\u7acb\u590f","\u5c0f\u6ee1","\u8292\u79cd","\u590f\u81f3","\u5c0f\u6691","\u5927\u6691","\u7acb\u79cb","\u5904\u6691","\u767d\u9732","\u79cb\u5206","\u5bd2\u9732","\u971c\u964d","\u7acb\u51ac","\u5c0f\u96ea","\u5927\u96ea","\u51ac\u81f3"};

/**
 * @brief 1900-2100各年的24节气日期速查表
 * @Array Of Property
 */
std::array<std::string, 201>   sTermInfo = {"9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf97c3598082c95f8c965cc920f",
	"97bd0b06bdb0722c965ce1cfcc920f","b027097bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e",
	"97bcf97c359801ec95f8c965cc920f","97bd0b06bdb0722c965ce1cfcc920f","b027097bd097c36b0b6fc9274c91aa",
	"97b6b97bd19801ec9210c965cc920e","97bcf97c359801ec95f8c965cc920f","97bd0b06bdb0722c965ce1cfcc920f",
	"b027097bd097c36b0b6fc9274c91aa","9778397bd19801ec9210c965cc920e","97b6b97bd19801ec95f8c965cc920f",
	"97bd09801d98082c95f8e1cfcc920f","97bd097bd097c36b0b6fc9210c8dc2","9778397bd197c36c9210c9274c91aa",
	"97b6b97bd19801ec95f8c965cc920e","97bd09801d98082c95f8e1cfcc920f","97bd097bd097c36b0b6fc9210c8dc2",
	"9778397bd097c36c9210c9274c91aa","97b6b97bd19801ec95f8c965cc920e","97bcf97c3598082c95f8e1cfcc920f",
	"97bd097bd097c36b0b6fc9210c8dc2","9778397bd097c36c9210c9274c91aa","97b6b97bd19801ec9210c965cc920e",
	"97bcf97c3598082c95f8c965cc920f","97bd097bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa",
	"97b6b97bd19801ec9210c965cc920e","97bcf97c3598082c95f8c965cc920f","97bd097bd097c35b0b6fc920fb0722",
	"9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf97c359801ec95f8c965cc920f",
	"97bd097bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e",
	"97bcf97c359801ec95f8c965cc920f","97bd097bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa",
	"97b6b97bd19801ec9210c965cc920e","97bcf97c359801ec95f8c965cc920f","97bd097bd07f595b0b6fc920fb0722",
	"9778397bd097c36b0b6fc9210c8dc2","9778397bd19801ec9210c9274c920e","97b6b97bd19801ec95f8c965cc920f",
	"97bd07f5307f595b0b0bc920fb0722","7f0e397bd097c36b0b6fc9210c8dc2","9778397bd097c36c9210c9274c920e",
	"97b6b97bd19801ec95f8c965cc920f","97bd07f5307f595b0b0bc920fb0722","7f0e397bd097c36b0b6fc9210c8dc2",
	"9778397bd097c36c9210c9274c91aa","97b6b97bd19801ec9210c965cc920e","97bd07f1487f595b0b0bc920fb0722",
	"7f0e397bd097c36b0b6fc9210c8dc2","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e",
	"97bcf7f1487f595b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa",
	"97b6b97bd19801ec9210c965cc920e","97bcf7f1487f595b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722",
	"9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e","97bcf7f1487f531b0b0bb0b6fb0722",
	"7f0e397bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b97bd19801ec9210c965cc920e",
	"97bcf7f1487f531b0b0bb0b6fb0722","7f0e397bd07f595b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa",
	"97b6b97bd19801ec9210c9274c920e","97bcf7f0e47f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722",
	"9778397bd097c36b0b6fc9210c91aa","97b6b97bd197c36c9210c9274c920e","97bcf7f0e47f531b0b0bb0b6fb0722",
	"7f0e397bd07f595b0b0bc920fb0722","9778397bd097c36b0b6fc9210c8dc2","9778397bd097c36c9210c9274c920e",
	"97b6b7f0e47f531b0723b0b6fb0722","7f0e37f5307f595b0b0bc920fb0722","7f0e397bd097c36b0b6fc9210c8dc2",
	"9778397bd097c36b0b70c9274c91aa","97b6b7f0e47f531b0723b0b6fb0721","7f0e37f1487f595b0b0bb0b6fb0722",
	"7f0e397bd097c35b0b6fc9210c8dc2","9778397bd097c36b0b6fc9274c91aa","97b6b7f0e47f531b0723b0b6fb0721",
	"7f0e27f1487f595b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa",
	"97b6b7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722",
	"9778397bd097c36b0b6fc9274c91aa","97b6b7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722",
	"7f0e397bd097c35b0b6fc920fb0722","9778397bd097c36b0b6fc9274c91aa","97b6b7f0e47f531b0723b0b6fb0721",
	"7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722","9778397bd097c36b0b6fc9274c91aa",
	"97b6b7f0e47f531b0723b0787b0721","7f0e27f0e47f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722",
	"9778397bd097c36b0b6fc9210c91aa","97b6b7f0e47f149b0723b0787b0721","7f0e27f0e47f531b0723b0b6fb0722",
	"7f0e397bd07f595b0b0bc920fb0722","9778397bd097c36b0b6fc9210c8dc2","977837f0e37f149b0723b0787b0721",
	"7f07e7f0e47f531b0723b0b6fb0722","7f0e37f5307f595b0b0bc920fb0722","7f0e397bd097c35b0b6fc9210c8dc2",
	"977837f0e37f14998082b0787b0721","7f07e7f0e47f531b0723b0b6fb0721","7f0e37f1487f595b0b0bb0b6fb0722",
	"7f0e397bd097c35b0b6fc9210c8dc2","977837f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721",
	"7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722","977837f0e37f14998082b0787b06bd",
	"7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd097c35b0b6fc920fb0722",
	"977837f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722",
	"7f0e397bd07f595b0b0bc920fb0722","977837f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721",
	"7f0e27f1487f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722","977837f0e37f14998082b0787b06bd",
	"7f07e7f0e47f149b0723b0787b0721","7f0e27f0e47f531b0b0bb0b6fb0722","7f0e397bd07f595b0b0bc920fb0722",
	"977837f0e37f14998082b0723b06bd","7f07e7f0e37f149b0723b0787b0721","7f0e27f0e47f531b0723b0b6fb0722",
	"7f0e397bd07f595b0b0bc920fb0722","977837f0e37f14898082b0723b02d5","7ec967f0e37f14998082b0787b0721",
	"7f07e7f0e47f531b0723b0b6fb0722","7f0e37f1487f595b0b0bb0b6fb0722","7f0e37f0e37f14898082b0723b02d5",
	"7ec967f0e37f14998082b0787b0721","7f07e7f0e47f531b0723b0b6fb0722","7f0e37f1487f531b0b0bb0b6fb0722",
	"7f0e37f0e37f14898082b0723b02d5","7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721",
	"7f0e37f1487f531b0b0bb0b6fb0722","7f0e37f0e37f14898082b072297c35","7ec967f0e37f14998082b0787b06bd",
	"7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722","7f0e37f0e37f14898082b072297c35",
	"7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722",
	"7f0e37f0e366aa89801eb072297c35","7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f149b0723b0787b0721",
	"7f0e27f1487f531b0b0bb0b6fb0722","7f0e37f0e366aa89801eb072297c35","7ec967f0e37f14998082b0723b06bd",
	"7f07e7f0e47f149b0723b0787b0721","7f0e27f0e47f531b0723b0b6fb0722","7f0e37f0e366aa89801eb072297c35",
	"7ec967f0e37f14998082b0723b06bd","7f07e7f0e37f14998083b0787b0721","7f0e27f0e47f531b0723b0b6fb0722",
	"7f0e37f0e366aa89801eb072297c35","7ec967f0e37f14898082b0723b02d5","7f07e7f0e37f14998082b0787b0721",
	"7f07e7f0e47f531b0723b0b6fb0722","7f0e36665b66aa89801e9808297c35","665f67f0e37f14898082b0723b02d5",
	"7ec967f0e37f14998082b0787b0721","7f07e7f0e47f531b0723b0b6fb0722","7f0e36665b66a449801e9808297c35",
	"665f67f0e37f14898082b0723b02d5","7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721",
	"7f0e36665b66a449801e9808297c35","665f67f0e37f14898082b072297c35","7ec967f0e37f14998082b0787b06bd",
	"7f07e7f0e47f531b0723b0b6fb0721","7f0e26665b66a449801e9808297c35","665f67f0e37f1489801eb072297c35",
	"7ec967f0e37f14998082b0787b06bd","7f07e7f0e47f531b0723b0b6fb0721","7f0e27f1487f531b0b0bb0b6fb0722"};

/**
 * @brief 数字转中文速查表
 * @Array Of Property
 * @trans ['日','一','二','三','四','五','六','七','八','九','十']
 */
std::array<std::string, 11> nStr1 = {"\u65e5","\u4e00","\u4e8c","\u4e09","\u56db","\u4e94","\u516d","\u4e03","\u516b","\u4e5d","\u5341"};

/**
 * @brief 日期转农历称呼速查表
 * @Array Of Property
 * @trans ['初','十','廿','卅']
 */
std::array<std::string, 4> nStr2 = {"\u521d","\u5341","\u5eff","\u5345"};

/**
 * @brief 月份转农历称呼速查表
 * @Array Of Property
 * @trans ['正','一','二','三','四','五','六','七','八','九','十','冬','腊']
 */
std::array<std::string, 13> nStr3 = {"\u6b63","\u4e8c","\u4e09","\u56db","\u4e94","\u516d","\u4e03","\u516b","\u4e5d","\u5341","\u51ac","\u814a"};

lunarData::lunarData(){
	
}

lunarData::~lunarData(){
	
}
		   
/**
 * @brief 返回农历y年一整年的总天数
 * @param y Year
 * @return Number
 * @eg:var count = calendar.lYearDays(1987) ;//count=387
 */
int lunarData::lYearDays(int y) {
	int i, sum = 348;
	for(i=0x8000; i>0x8; i>>=1) { sum += (lunarInfo[y-1900] & i)? 1: 0; }
	return(sum+leapDays(y));
}

/**
 * @brief 返回农历y年闰月是哪个月；若y年没有闰月 则返回0
 * @param y Year
 * @return Number (0-12)
 * @eg:var leapMonth = calendar.leapMonth(1987) ;//leapMonth=6
 */
int lunarData::leapMonth(int y) { //闰字编码 \u95f0
	return(lunarInfo[y-1900] & 0xf);
}

/**
 * @brief 返回农历y年闰月的天数 若该年没有闰月则返回0
 * @param y Year
 * @return Number (0、29、30)
 * @eg:var leapMonthDay = calendar.leapDays(1987) ;//leapMonthDay=29
 */
int lunarData::leapDays(int y) {
	if(leapMonth(y))  {
		return((lunarInfo[y-1900] & 0x10000)? 30: 29);
	}
	return 0 ;
}

/**
 * @brief 返回农历y年m月（非闰月）的总天数，计算m为闰月时的天数请使用leapDays方法
 * @param y Year
 * @return Number (-1、29、30)
 * @eg:var MonthDay = calendar.monthDays(1987,9) ;//MonthDay=29
 */
int lunarData::monthDays(int y, int m) {
	if(m>12 || m<1) {return -1;}//月份参数从1至12，参数错误返回-1
	int count = (lunarInfo[y-1900] & (0x10000>>m))? 30: 29;
	return count;
}

/**
 * @brief 返回公历(!)y年m月的天数
 * @param y Year
 * @param m Month
 * @return Number (-1、28、29、30、31)
 * @eg:var solarMonthDay = calendar.leapDays(1987) ;//solarMonthDay=30
 */
int lunarData::solarDays(int y, int m) {
	if(m>12 || m<1) {return -1;} //若参数错误 返回-1
	int ms = m-1;
	if(ms==1) { //2月份的闰平规律测算后确认返回28或29
		return((((y%4 == 0) && (y%100 != 0)) || (y%400 == 0))? 29: 28);
	}else {
		return(solarMonth[ms]);
	}
}

/**
 * @brief 农历年份转换为干支纪年
 * @param  lYear 农历年的年份数
 * @return Cn string
 */
std::string lunarData::toGanZhiYear(int lYear) {
	int ganKey = (lYear - 3) % 10;
	int zhiKey = (lYear - 3) % 12;
	if(ganKey == 0) ganKey = 10;//如果余数为0则为最后一个天干
	if(zhiKey == 0) zhiKey = 12;//如果余数为0则为最后一个地支
	return Gan[ganKey-1] + Zhi[zhiKey-1];
}

/**
 * @brief 传入offset偏移量返回干支
 * @param offset 相对甲子的偏移量
 * @return Cn string
 */
std::string lunarData::toGanZhi(int offset) {
	return Gan[offset%10] + Zhi[offset%12];
}

/**
 * @brief 传入公历(!)y年获得该年第n个节气的公历日期
 * @param y 公历年(1900-2100)
 * @param n 二十四节气中的第几个节气(1~24)；从n=1(小寒)算起
 * @return day Number
 * @eg:var _24 = calendar.getTerm(1987,3) ;//_24=4;意即1987年2月4日立春
 */
int lunarData::getTerm(int y, int n) {
	if (y < 1900 || y > 2100) { return -1; }
	if (n < 1 || n > 24) { return -1; }
	
	// 获取对应年份的节气信息
	//	std::string _table = sTermInfo[y - 1900];
	std::string _table = "97b6b97bd19801ec9210c965cc920e";//用1901年的节气信息作测试
	
	// 解析节气信息
	std::vector<std::string> _info;
	for (int i = 0; i < 6; ++i) {
		std::string hexStr = "0x" + _table.substr(i * 5, 5); // 提取5个字符的十六进制子串
		// 转换为十进制
		int dec = std::stoi(hexStr, nullptr, 16);
		// 转换为string
		hexStr = std::to_string(dec);
		_info.push_back(hexStr);
	}
	// _info[0].substr(0,1)转化为十进制
	
	std::array<std::string, 24> _calday = {
		_info[0].substr(0,1),
		_info[0].substr(1,2),
		_info[0].substr(3,1),
		_info[0].substr(4,2),
		
		_info[1].substr(0,1),
		_info[1].substr(1,2),
		_info[1].substr(3,1),
		_info[1].substr(4,2),
		
		_info[2].substr(0,1),
		_info[2].substr(1,2),
		_info[2].substr(3,1),
		_info[2].substr(4,2),
		
		_info[3].substr(0,1),
		_info[3].substr(1,2),
		_info[3].substr(3,1),
		_info[3].substr(4,2),
		
		_info[4].substr(0,1),
		_info[4].substr(1,2),
		_info[4].substr(3,1),
		_info[4].substr(4,2),
		
		_info[5].substr(0,1),
		_info[5].substr(1,2),
		_info[5].substr(3,1),
		_info[5].substr(4,2)
	};
	// 返回节气日期的整数值
	return std::stoi(_calday[n-1]);
}

/**
 * @brief 传入农历数字月份返回汉语通俗表示法
 * @param m month
 * @return Cn string
 * @eg:var cnMonth = calendar.toChinaMonth(12) ;//cnMonth='腊月'
 */
std::string lunarData::toChinaMonth(int m) { // 月 => \u6708
	if(m>12 || m<1) {return "";} //若参数错误 返回-1
	std::string s = nStr3[m-1];
	s+= "\u6708";//加上月字
	return s;
}

/**
 * @brief 传入农历日期数字返回汉字表示法
 * @param d day
 * @return Cn string
 * @eg:var cnDay = calendar.toChinaDay(21) ;//cnMonth='廿一'
 */
std::string lunarData::toChinaDay(int d){ //日 => \u65e5
	std::string s;
	switch (d) {
		case 10:
			s = "\u521d\u5341"; break;
		case 20:
			s = "\u4e8c\u5341"; break;
			break;
		case 30:
			s = "\u4e09\u5341"; break;
			break;
		default :
			s = nStr2[floor(d/10)];
			s += nStr1[d%10];
	}
	return(s);
}

/**
 * @brief 年份转生肖[!仅能大致转换] => 精确划分生肖分界线是“立春”
 * @param y year
 * @return Cn string
 * @eg:var animal = calendar.getAnimal(1987) ;//animal='兔'
 */
std::string lunarData::getAnimal(int y) {
	return Animals[(y - 4) % 12];
}

/**
 * @brief 计算开始时间到结束时间的天数
 * 
 * @param start_y 开始年
 * @param start_m 开始月
 * @param start_d 开始日
 * @param y 结束年
 * @param m 结束月
 * @param d 结束日
 * @return int 
 */
int lunarData::getOffsetDays(int start_y, int start_m, int start_d, int y, int m, int d){
	// 构造开始时间
	struct tm start = {0};
	start.tm_year = start_y - 1900;  // 年份从1900开始
	start.tm_mon = start_m - 1;     // 月份从0开始
	start.tm_mday = start_d;          // 日
	
	// 构造结束时间
	struct tm end = {0};
	end.tm_year = y - 1900;  // 年份从1900开始
	end.tm_mon = m - 1;     // 月份从0开始
	end.tm_mday = d;          // 日
	
	// 使用mktime函数将tm结构体转换为time_t类型（秒数）
	time_t t1 = mktime(&start);
	time_t t2 = mktime(&end);
	
	// 计算两个日期之间的天数差
	int offsetDay = difftime(t2, t1) / (60 * 60 * 24);
	return offsetDay;
}

// 获取时辰
int lunarData::getShiChen(int hour, int minute) {
//	printf("hour:%d, minute:%d\n", hour, minute);

	int currentTime = static_cast<int>((hour + 1) / 2); // 每个时辰对应的时间戳
	if (currentTime == 12) currentTime = 0;

//	printf("currentTime:%d\n", currentTime);
	return currentTime;
}

/**
 * @brief 传入阳历年月日获得详细的公历、农历object信息 <=>JSON
 * @param y  solar year
 * @param m  solar month
 * @param d  solar day  
 */
bool lunarData::updataSolar2lunar(int y, int m, int d, int hour, int minute) { 
	//参数区间1900.1.31~2100.12.31 
//	m_data.reset();
	
	//年份限定、上限
	if(y<1900 || y>2100) {
		printf("年份超出范围(1900-2100)");
		return false;// undefined转换为数字变为NaN
	}

	//公历传参最下限
	if(y==1900&&m==1&&d<31) {
		printf("日期超出范围(1900.1.31)");
		return false;
	}
	
	int i, temp=0;
	
	// y年m月d日距离1900.1.31多少时间
	int offsetDay = getOffsetDays(1900, 1, 31, y, m, d);
	int offset = offsetDay;
	
	for(i=1900; i<2101 && offset>0; i++) {
		temp = lYearDays(i);
		offset -= temp;
	}
	if(offset<0) {
		offset+=temp; i--;
	}
	
	//农历年
	int lYear = i;
	int leap = leapMonth(i); //闰哪个月
	bool isLeap = false;
	
	//效验闰月
	for(i=1; i<13 && offset>0; i++) {
		//闰月
		if(leap>0 && i==(leap+1) && isLeap==false){
			--i;
			isLeap = true; temp = leapDays(lYear); //计算农历闰月天数
		}
		else{
			temp = monthDays(lYear, i);//计算农历普通月天数
		}
		//解除闰月
		if(isLeap==true && i==(leap+1)) { isLeap = false; }
		offset -= temp;
	}
	// 闰月导致数组下标重叠取反
	if(offset==0 && leap>0 && i==leap+1)
	{
		if(isLeap){
			isLeap = false;
		}else{
			isLeap = true; --i;
		}
	}
	if(offset<0)
	{
		offset += temp; --i;
	}
	//农历月
	int lMonth = i;
	//农历日
	int lDay = offset + 1;

	//天干地支处理
	std::string gzYear = toGanZhiYear(lYear);
	
	// 当月的两个节气
	int firstNode  = getTerm(y,(m*2-1));//返回当月「节」为几日开始
	int secondNode = getTerm(y,(m*2));//返回当月「节」为几日开始
	
	// 依据12节气修正干支月
	std::string gzMonth = toGanZhi((y-1900)*12+m+11);
	if(d>=firstNode) {
		gzMonth  = toGanZhi((y-1900)*12+m+12);
	}

	//日柱 当月一日与 1900/2/20 相差天数
	int dayCyclical = getOffsetDays(1900, 2, 20, y, m, d);
	std::string gzDay = toGanZhi(dayCyclical);

	//生肖
	std::string Animal = getAnimal(y);
	// 中国月
	std::string IMonthCn = isLeap ? "闰" + nStr3[lMonth-1] + "\u6708" : "";//月
	// 中国日
	std::string IDayCn = toChinaDay(lDay);

	//传入的日期的节气与否
	bool isTerm = false;
	std::string Term;
	if(firstNode==d) {
		isTerm = true;
		Term = solarTerm[m*2-2];
	}
	if(secondNode==d) {
		isTerm = true;
		Term = solarTerm[m*2-1];
	}
	
	//星期几
	int nWeek = (offsetDay + 3) % 7; //1900年1月31日是周三
	//数字表示周几顺应天朝周一开始的惯例
	if(nWeek==0) {
		nWeek = 7;
	}
	std::string cWeek = nStr1[nWeek];

	//是否今天
	bool isToday = false;
	time_t now = time(nullptr);
	struct tm* tm_now = localtime(&now); // 获取当前系统时间
	if (tm_now->tm_year + 1900 == y &&
		tm_now->tm_mon + 1 == m &&
		tm_now->tm_mday == d) {
		isToday = true;
	} else {
		isToday = false;
	}

//	// 更新m_data所有的参数
//	m_data.cYear = y;
//	m_data.cMonth = m;
//	m_data.cDay = d;
//	m_data.cHour = hour;
//	m_data.cMinute = minute;
//
//	m_data.lYear = lYear;
//	m_data.lMonth = lMonth;
//	m_data.lDay = lDay;
//
//	m_data.gzYear = gzYear;
//	m_data.gzMonth = gzMonth;
//	m_data.gzDay = gzDay;
//
//	m_data.Animal = Animal;
//	m_data.IMonthCn = IMonthCn;
//	m_data.IDayCn = IDayCn;
//
//	m_data.isLeap = isLeap;
//	m_data.leap = leap;
//
//	m_data.isTerm = isTerm;
//	m_data.Term = Term;
//
//	m_data.cWeek = cWeek;
//	m_data.nWeek = nWeek;
//
//	m_data.isToday = isToday;

//	printf("公历:%d年%d月%d日\n", y, m, d);
//	printf("农历:%d年%d月%d日\n", lYear, lMonth, lDay);
//	printf("农历:%s%s%s\n", (isLeap?"闰":""), nStr3[lMonth-1].c_str(), "\u6708");
//	printf("干支:%s年 %s月 %s日\n", gzYear.c_str(), gzMonth.c_str(), gzDay.c_str());
//	printf("生肖:%s\n", Animal.c_str());
//	printf("节气:%s\n", isTerm?Term.c_str():"");
//	printf("周:%s\n", cWeek.c_str());
//	printf("今天:%s\n", isToday?"是":"否");


	return true;
}


/// 获取农历时间
/// @param y 年
/// @param m 月
/// @param d 日
/// @param hour 时
/// @param minute 分
const char* lunarData::getLunarData(int y, int m, int d, int hour, int minute){
//	printf("公历:%d年%d月%d日\n", y, m, d);
	//年份限定、上限
	if(y<1900 || y>2100) {
		printf("年份超出范围(1900-2100)");
		return "";// undefined转换为数字变为NaN
	}

	//公历传参最下限
	if(y==1900&&m==1&&d<31) {
		printf("日期超出范围(1900.1.31)");
		return "";
	}
	
	int i, temp=0;
	
	// y年m月d日距离1900.1.31多少时间
	int offsetDay = getOffsetDays(1900, 1, 31, y, m, d);
	int offset = offsetDay;
	
	for(i=1900; i<2101 && offset>0; i++) {
		temp = lYearDays(i);
		offset -= temp;
	}
	if(offset<0) {
		offset+=temp; i--;
	}
	
	//农历年
	int lYear = i;
	int leap = leapMonth(i); //闰哪个月
	bool isLeap = false; 

	//效验闰月
	for(i=1; i<13 && offset>0; i++) {
		//闰月
		if(leap>0 && i==(leap+1) && isLeap==false){
			--i;
			isLeap = true; temp = leapDays(lYear); //计算农历闰月天数
		}
		else{
			temp = monthDays(lYear, i);//计算农历普通月天数
		}
		//解除闰月
		if(isLeap==true && i==(leap+1)) { isLeap = false; }
		offset -= temp;
	}
	// 闰月导致数组下标重叠取反
	if(offset==0 && leap>0 && i==leap+1)
	{
		if(isLeap){
			isLeap = false;
		}else{
			isLeap = true; --i;
		}
	}
	if(offset<0)
	{
		offset += temp; --i;
	}
	//农历月
	int lMonth = i;
	//农历日
	int lDay = offset + 1;
	
	// 时辰
	int nShiChen = getShiChen(hour, minute);
	std::string sShichen = Zhi[nShiChen] + "时";
	
	//返回农历时间
	std::string str = std::to_string(lYear) + "年 " + std::to_string(lMonth) + "月 " + std::to_string(lDay) + "日 " + sShichen;
	if(isLeap){
		str = std::to_string(lYear) + "年 " +  "闰" + std::to_string(lMonth) + "月 " + std::to_string(lDay) + "日 " + sShichen;
	}
	
	// 申请动态内存存储农历时间字符串
	const int bufferSize = 1000;
	char* lunarBuffer = (char*)malloc(bufferSize * sizeof(char));
	if (lunarBuffer == nullptr) {
		printf("内存分配失败\n");
		return ""; // 返回空字符串表示错误
	}
	
	// 构造农历时间字符串
	sprintf(lunarBuffer, "%s", str.c_str());
	
//	printf("%s\n", lunarBuffer); // 输出农历时间
	
	// 返回动态分配的内存地址，注意需要在调用者处理后释放
	return lunarBuffer;
	
}

} //namespace
