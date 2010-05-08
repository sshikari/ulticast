//
//  Player.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "Utils.h"
#import "Team.h"

@implementation Player

@synthesize playerId;
@synthesize number;
@synthesize nickname;
@synthesize firstName;
@synthesize lastName;
@synthesize position;
@synthesize teams;
 

- (id) initFromDictionary: (NSDictionary*) dict {
	self = [super init];
	[self setPlayerId:[[dict objectForKey: @"id"] longValue]];
	[self setNumber:[[dict objectForKey: @"number"] intValue]];
	[self setNickname:[Utils nilify:[dict objectForKey: @"nickname"]]];
	[self setFirstName:[Utils nilify:[dict objectForKey: @"firstName"]]];
	[self setLastName:[Utils nilify:[dict objectForKey: @"lastName"]]];
	[self setPosition:[Utils nilify:[dict objectForKey: @"position"]]];
	// TODO deJSON list if available
 	NSArray *arrayTeams = [Utils nilify:[dict objectForKey: @"teams"]];
	if (arrayTeams != nil && [arrayTeams count] != 0) {
		[self setTeams:[Utils fromJSON:arrayTeams: [Team class]]]; 
	}
	return self;
}

- (id) initWith: (int) num : (NSString*) fName {
    if (self = [super init]) {
		[self setNumber:num];
		[self setFirstName:fName];
	}
	return self;
}


- (NSString*) idString {
	return [NSString stringWithFormat:@"%d - %@", number, nickname];			
}
- (NSString*) description {
	return [self idString];
}

//long playerId;
//int number;
//NSString* nickname;
//NSString* firstName;
//NSString* lastName;
//NSString* position;
//NSArray* teams;

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInt:playerId forKey:@"playerId"];
	[aCoder encodeInt:number forKey:@"number"];
	[aCoder encodeObject:nickname forKey:@"nickname"];
	[aCoder encodeObject:firstName forKey:@"firstName"];
	[aCoder encodeObject:lastName forKey:@"lastName"];
	[aCoder encodeObject:position forKey:@"position"];
	[aCoder encodeObject:teams forKey:@"teams"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	playerId = [aDecoder decodeIntForKey:@"playerId"];
	number = [aDecoder decodeIntForKey:@"number"];	
	nickname = [[aDecoder decodeObjectForKey:@"nickname"] retain];
	firstName = [[aDecoder decodeObjectForKey:@"firstName"] retain];
	lastName = [[aDecoder decodeObjectForKey:@"lastName"] retain];
	position = [[aDecoder decodeObjectForKey:@"position"] retain];
	teams = [[aDecoder decodeObjectForKey:@"teams"] retain];	
	return self;
}

- (NSComparisonResult)compare:(id)otherObject {
    if (self.number == [otherObject number])
		return NSOrderedSame;
	else if (self.number > [otherObject number])
		return NSOrderedDescending;
	else {
		return NSOrderedAscending;
	}

}

- (id)proxyForJson {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setValue:[NSNumber numberWithLong:playerId] forKey:@"id"];
	[dict setValue:firstName forKey:@"firstName"];
	return dict;	
}

@end
