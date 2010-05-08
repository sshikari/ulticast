//
//  CallEvent.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEvent.h"
#import "Player.h"

@interface CallEvent : GameEvent {
	NSString* callType;
	BOOL contested;
	Player *caller;
	Player *fouler;
}

+ (NSArray*) callTypes;
+ (BOOL) isDefensiveCall: (NSString*) callType;
- (BOOL) isDefensiveCall;

//-(id) initWithParams: (NSString*) cType: (NSString*) tName: (NSString*) plyer;

//@property (nonatomic, retain) NSString* player;
//@property (nonatomic, retain) NSString* fouler;
@property (nonatomic, retain) Player* caller;
@property (nonatomic, retain) Player* fouler;

@property (nonatomic, retain) NSString* callType;
@property BOOL contested;

@end
