//
//  TurnEvent.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEvent.h"
#import "Player.h"

@interface TurnEvent : GameEvent {
	NSString* turnType;
	Player* player;	
}

+ (NSArray*) turnTypes;
//-(id) initWithParams: (NSString*) tType: (NSString*) tName: (NSString*) plyer;

@property (nonatomic, retain) Player* player;
@property (nonatomic, retain) NSString* turnType;


@end
