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

@synthesize number;
@synthesize nickname;
@synthesize firstName;
@synthesize lastName;
@synthesize position;
@synthesize teams;
 

- (id) initFromDictionary: (NSDictionary*) dict {
	self = [super init];
	self = [super initFromDictionary:dict];
	[self setNumber:[Utils nilifyInt: [dict objectForKey: @"number"]]];
	[self setNickname:[Utils nilify:[dict objectForKey: @"nickname"]]];
	[self setFirstName:[Utils nilify:[dict objectForKey: @"first_name"]]];
	[self setLastName:[Utils nilify:[dict objectForKey: @"last_name"]]];
	[self setPosition:[Utils nilify:[dict objectForKey: @"position"]]];
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
	[super encodeWithCoder:aCoder];
	[aCoder encodeInt:number forKey:@"number"];
	[aCoder encodeObject:nickname forKey:@"nickname"];
	[aCoder encodeObject:firstName forKey:@"firstName"];
	[aCoder encodeObject:lastName forKey:@"lastName"];
	[aCoder encodeObject:position forKey:@"position"];
	[aCoder encodeObject:teams forKey:@"teams"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	[super initWithCoder:aDecoder];
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
	NSMutableDictionary *dict = [super proxyForJson];
	[dict setValue:nickname forKey:@"nickname"];
	[dict setValue:firstName forKey:@"first_name"];
	[dict setValue:lastName forKey:@"last_name"];
	[dict setValue:[NSNumber numberWithInt: number] forKey:@"number"];

	return dict;	
}

@end
