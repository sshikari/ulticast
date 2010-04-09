//
//  Player.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize playerId;
@synthesize number;
@synthesize shortName;
@synthesize firstName;
@synthesize lastName;
@synthesize position;
@synthesize teams;
 

- (id) initWith: (int) num : (NSString*) fName {
    if (self = [super init]) {
		[self setNumber:num];
		[self setFirstName:fName];
	}
	return self;
}


- (NSString*) idString {
	return [NSString stringWithFormat:@"%d - %@", number, firstName];			
}
- (NSString*) description {
	return [self idString];
}

- (id)proxyForJson {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setValue:[NSNumber numberWithLong:playerId] forKey:@"id"];
	[dict setValue:firstName forKey:@"firstName"];
	return dict;	
}

@end
