//
//  PassEvent.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PassEvent.h"
#import "Team.h"

@implementation PassEvent

@synthesize player;


-(id) initWithParams: (Team*) t: (Player*) plyer {
	if (self = [super initWithParams:EVENT_PASS: t]) {
		[self setPlayer: plyer];
	}
	return self;
}

- (id)proxyForJson {
	NSMutableDictionary *dict = [super proxyForJson];
	[dict setValue:team forKey:@"teamName"];
	[dict setValue:player forKey:@"player"];
	return dict;	
}

@end
