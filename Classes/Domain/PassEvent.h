//
//  PassEvent.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEvent.h"
#import "Player.h"
#import "Team.h"

@interface PassEvent : GameEvent {
	Player* player;
}

-(id) initWithParams: (Team*) team: (Player*) plyer;

@property (nonatomic, retain) Player* player;
@end
