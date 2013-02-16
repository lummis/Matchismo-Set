//
//  Common.h
//  Matchismo&Set
//
//  Created by Robert Lummis on 2/11/13.
//  Copyright (c) 2013 Electric Turkey Software. All rights reserved.
//

#ifndef Matchismo_Set_Common_h
#define Matchismo_Set_Common_h

#define CCLOG(...) NSLog(__VA_ARGS__)

#define LOG CCLOG( @"\n\n|... THREAD: %@\n|... SELF:   %@\n|... METHOD: %@(%d)", \
[NSThread currentThread], self, NSStringFromSelector(_cmd), __LINE__) ;

#endif
