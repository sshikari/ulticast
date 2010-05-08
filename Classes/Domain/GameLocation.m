//
//  GameLocation.m
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameLocation.h"


@implementation GameLocation

@synthesize description;

- (id) initWithDesc: (NSString*) desc {
	if (self = [super init]) {
		[self setDescription:desc];
	}
	return self;
}

- (NSString*) description {
    return description;	
}
@end
