//
//  QuickGameInfo.m
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QuickGameInfo.h"


@implementation QuickGameInfo

@synthesize myTeam;
@synthesize opponentTeam;
@synthesize location;
@synthesize isHomeGame;
@synthesize weatherDescription;
@synthesize wind;	


- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeBool:isHomeGame forKey:@"isHomeGame"];
	[aCoder encodeObject:location forKey:@"location"];
	[aCoder encodeObject:weatherDescription forKey:@"weatherDescription"];
	[aCoder encodeObject:wind forKey:@"wind"];
	// TODO encode myTeam and opponentTeam -- this is excessive for now.
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	isHomeGame = [aDecoder decodeBoolForKey:@"isHomeGame"];
	location = [[aDecoder decodeObjectForKey:@"location"] retain];
	weatherDescription = [[aDecoder decodeObjectForKey:@"weatherDescription"] retain]; 
	wind = [[aDecoder decodeObjectForKey:@"wind"] retain]; 
	return self;
}


@end
