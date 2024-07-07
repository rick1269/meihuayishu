#ifndef LUNAR_CALENDAR_H
#define LUNAR_CALENDAR_H

#ifdef __cplusplus
extern "C" {
#endif
// 获取农历日期
const char* getLunarDate(int year, int month, int day, int hour, int minute);

// 获取四纲的信息
const char* getSiGangGanZhi(int year, int month, int day, int hour, int minute);

// 获取空亡信息
const char* getRiKongWang(int year, int month, int day, int hour, int minute);

#ifdef __cplusplus
}
#endif

#endif // LUNAR_CALENDAR_H
