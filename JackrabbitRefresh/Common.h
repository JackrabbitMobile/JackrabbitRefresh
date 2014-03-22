//
//  Common.h
//  JackrabbitRefresh
//
//  Created by Anthony Blatner on 2/18/14.
//  Copyright (c) 2014 Jackrabbit Mobile. All rights reserved.
//

#ifndef JackrabbitRefresh_Common_h
#define JackrabbitRefresh_Common_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#endif