//
//  ScoreEvent.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEvent.h"
#import "Team.h"
#import "Player.h"

@interface ScoreEvent : GameEvent {
	int teamScore;
	Player* player;
	Player* assister;
	NSString* distanceDescriptor;
}

+ (NSArray*) distanceOptions;

//- (id) initWithParams: (NSString*) team: (int) tscore: (NSString*) play: (NSString*) assist: 
//					   (NSString*) distance: (NSString*) note;
	
- (id) initWith: (Team*) team;
@property (nonatomic, retain) Player* player;
@property (nonatomic, retain) Player* assister;
@property (nonatomic, retain) NSString* distanceDescriptor;
@property int teamScore;
@end
