#ifndef LUNAR_CALENDAR_H
#define LUNAR_CALENDAR_H

#ifdef __cplusplus
extern "C" {
#endif

void gregorian_to_lunar(int year, int month, int day);
const char* convertToLunarDate(int year, int month, int day);

#ifdef __cplusplus
}
#endif

#endif // LUNAR_CALENDAR_H
