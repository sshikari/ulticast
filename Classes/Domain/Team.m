//
//  Team.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Team.h"


@implementation Team

@synthesize teamId;
@synthesize name;
@synthesize players;


- (id) initWithName: (NSString*) n {
	if (self = [super init]) {
		[self setName: n];	
	}
	return self;
}

- (Player*) playerAtIndex: (int) i {
    return [players objectAtIndex: i];	
}

- (NSArray*) playerNames {
	NSMutableArray* names = [NSMutableArray arrayWithCapacity:[players count]];
	for (int i=0; i<[players count]; i++) {
		[names addObject:[[players objectAtIndex:i] firstName] ];
	}
	return names; //TODO... this breaks... why? autorelease];
}

- (BOOL) isMyTeam: (NSString*) n {
	return [name isEqualToString:n];
}

- (id)proxyForJson {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setValue:name forKey:@"teamName"];
	//[dict setValue:players forKey:@"players"];
	return dict;	
}


@end
