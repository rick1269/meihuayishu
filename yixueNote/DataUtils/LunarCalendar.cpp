#include "LunarCalendar.h"
#include <iostream>
#include <iomanip>
#include <cmath>
#include <string.h>

using namespace std;

string lunarMonth[] = {" ", "正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"};
string lunarDay[] = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"};
string lunarDay2[] = {"初", "十", "廿", "卅"};
string lunarHour[] = {"子", "丑", "寅", "卯"};

/** 农历查询表 */
unsigned int sg_lunarCalendar[199] = {
	0x0c950, /*1939年*/   /*查询公历1940年1月，农历其实是1939年*/
	0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557,
	0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5d0, 0x14573, 0x052d0, 0x0a9a8, 0x0e950, 0x06aa0,
	0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,
	0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x0d558, 0x0b540, 0x0b5a0, 0x195a6,
	0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
	0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x055c0, 0x0ab60, 0x096d5, 0x092e0,
	0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
	0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
	0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
	0x05aa0, 0x076a3, 0x096d0, 0x04bd7, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
	0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0
};

// 21世纪C值
float C_value_21[] = {3.87, 18.73, 5.63, 20.646, 4.81, 20.1, 5.52, 21.04, 5.678, 21.37, 7.108, 22.83, 7.5, 23.13, 7.646, 23.042, 8.318, 23.438, 7.438, 22.36, 7.18, 21.94, 5.4055, 20.12};
// 20世纪C值
float C_value_20[] = {4.6295, 19.4599, 6.3826, 21.4155, 5.59, 20.888, 6.318, 21.86, 6.5, 22.2, 7.928, 23.65, 28.35, 23.95, 8.44, 23.822, 9.098, 24.218, 8.218, 23.08, 7.9, 22.6, 6.11, 20.84};
// 节气基础月
float C_month[] = {2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13};

/**
 * 判断year年是否是闰年
 */
bool is_leap_year(int year)
{
	// 可以被4且100整除或者可以被400整除
	return ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
}

/**
 * 获取year年month月有多少天
 */
int get_days_of_month(int year, int month)
{
	// 平年各月公历天数
	int days[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
	if (is_leap_year(year) && month == 2)
		return 29;
	else
		return days[month - 1];
}

/**
 * 获取year年month月day日到1939年1月1日的天数
 */
int get_days_to_1939(int year, int month, int day)
{
	int days = 0;
	// 从1939年开始计算,直到year-1年,它们都是整数年
	for (int i = year - 1; i >= 1939; i--)
	{
		if (is_leap_year(i))
			days += 366;
		else
			days += 365;
	}
	// 计算year年1月到year年month-1月,它们是整数月
	for (int i = month - 1; i > 0; i--)
	{
		days += get_days_of_month(year, i);
	}
	// 计算year年month月1日到year年month月day日天数
	days += day;
	return days - 1;
}

/**
 * 判断润年闰月是大月还是小月
 */
bool is_large_month_of_leap_year(int year)
{
	// 查表找出是否为闰月 判断high是不是为0
	int high = (sg_lunarCalendar[year - 1939] >> 16);
	if (high == 0x00)
		return false;
	else
		return true;
}
/**
 * 返回 润几月  0代表不闰
 */
int get_nonth_of_leap_year(int year)
{
	// 输出农历润几月
	int month = sg_lunarCalendar[year - 1939] & 0xF;
	return month;
}

/**
 * 判断农历某年某月多少天
 */
int get_days_of_lunar_month(int year, int month)
{
	// 查表，根据大小月，计算农历月天数
	int bit = 1 << (16 - month);
	if ((sg_lunarCalendar[year - 1939] & bit) == 0)
		return 29;
	else
		return 30;
}

// 判断某年农历多少天
int get_days_of_lunar_year(int year)
{
	int days = 0;
	// 农历十二个月天数
	for (int i = 1; i <= 12; i++)
	{
		days += get_days_of_lunar_month(year, i);
	}
	// 假如有闰月，加上闰月天数
	if (get_nonth_of_leap_year(year) != 0)
	{
		if (is_large_month_of_leap_year(year))
			days += 30;
		else
			days += 29;
	}
	return days;
}

/**
 * 输出农历日历
 */
void print_lunar_date(int days)
{
	int year = 1939, month = 1, day = 1;
	// 由于1939年1月1日往往是农历1938年，所以减去48天，从1939年正月初一计算，因为本计算器计算范围为1940年-2040年 所以可以满足
	days -= 48;

	// 判断减去下一年的天数，会不会是负值，不是便减去并增加农历年
	for (int i = 1939; (days - get_days_of_lunar_year(i)) > 0; i++)
	{
		days -= get_days_of_lunar_year(i);
		year = i + 1;
	}
	int num;
	int signal = 0;
	// 判断减去下一月天数，会不会是负值，不会便农历月加1
	for (int j = 1; ((days - get_days_of_lunar_month(year, j)) > 0) && j < 12; j++)
	{
		days -= get_days_of_lunar_month(year, j);
		if (j == get_nonth_of_leap_year(year))
		{
			if (is_large_month_of_leap_year(year))
			{
				days -= 30;
				num = 30;
			}
			else
			{
				days -= 29;
				num = 29;
			}
		}
		// 当减去农历月的时候，加入变为负值，那么再加回来
		if (days < 0)
		{
			// 农历闰月标记
			signal = 1;
			days += num;
			month = j;
			break;
		}
		month = month + 1;
	}
	// 剩余天数便是农历日
	day = days;
	cout << year << "年";
	if (signal == 1)
		cout << " 闰";
	cout << lunarMonth[month];
	if (day > 0 && day <= 10)
	{
		cout << "初" << lunarDay[day];
	}
	else if (day > 10 && day < 20)
	{
		cout << "十" << lunarDay[day % 10];
	}
	else if (day == 20)
	{
		cout << "二十";
	}
	else if (day > 20 && day < 30)
	{
		cout << "廿" << lunarDay[day % 10];
	}
	else if (day == 30)
	{
		cout << "三十";
	}
	cout << endl;
}

/**
 * 打印农历
 */
void gregorian_to_lunar(int year, int month, int day)
{
	if (month < 1 || month > 12 || day < 1 || day > get_days_of_month(year, month))
	{
		cout << "日期输入出错，请确保日期正确性！" << endl;
		return;
	}
	cout << "公历:" << year << "年" << month << "月" << day << "日"
		 << "   "
		 << "农历:";
	int days = get_days_to_1939(year, month, day);
	// 根据天数打印农历
	print_lunar_date(days);
}

/**
 * 返回农历字符串
 */
const char* convertToLunarDate(int year, int month, int day)
{
	if (month < 1 || month > 12 || day < 1 || day > get_days_of_month(year, month))
	{
		return "日期输入出错，请确保日期正确性！";
	}

	static std::string result;
	result.clear();
	
	int days = get_days_to_1939(year, month, day);
	int nlunarYear = 1939, nlunarMonth = 1, nlunarDay = 1;
	days -= 48;

	for (int i = 1939; (days - get_days_of_lunar_year(i)) > 0; i++)
	{
		days -= get_days_of_lunar_year(i);
		nlunarYear = i + 1;
	}
	int num = 0;
	int signal = 0;
	for (int j = 1; ((days - get_days_of_lunar_month(nlunarYear, j)) > 0) && j < 12; j++)
	{
		days -= get_days_of_lunar_month(nlunarYear, j);
		if (j == get_nonth_of_leap_year(nlunarYear))
		{
			if (is_large_month_of_leap_year(nlunarYear))
			{
				days -= 30;
				num = 30;
			}
			else
			{
				days -= 29;
				num = 29;
			}
		}
		if (days < 0)
		{
			signal = 1;
			days += num;
			nlunarMonth = j;
			break;
		}
		nlunarMonth = nlunarMonth + 1;
	}
	nlunarDay = days;
	result += std::to_string(nlunarYear) + "年";
	if (signal == 1)
		result += " 闰";
	result += lunarMonth[nlunarMonth];
	if (nlunarDay > 0 && nlunarDay <= 10)
	{
		result += "初" + lunarDay[nlunarDay];
	}
	else if (nlunarDay > 10 && nlunarDay < 20)
	{
		result += "十" + lunarDay[nlunarDay % 10];
	}
	else if (nlunarDay == 20)
	{
		result += "二十";
	}
	else if (nlunarDay > 20 && nlunarDay < 30)
	{
		result += "廿" + lunarDay[nlunarDay % 10];
	}
	else if (nlunarDay == 30)
	{
		result += "三十";
	}
	printf("result %c", result.c_str());
	return result.c_str();
}

