//
//  DomainObject.m
//  ulticast
//
//  Created by Richard Chang on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DomainObject.h"


@implementation DomainObject

@synthesize dirty, uid, version;


-(id) init {
    if (self = [super init]) {
		[self setDirty:NO];
	} 
	return self;
}

- (id) initFromDictionary: (NSDictionary*) dict {
	[self setUid:[[dict objectForKey: @"id"] longValue]];
	[self setVersion:[[dict objectForKey: @"version"] longValue]];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	uid = [aDecoder decodeIntForKey:@"id"];	
	version = [aDecoder decodeIntForKey:@"version"];	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInt:uid forKey:@"id"];
	[aCoder encodeInt:version forKey:@"version"];
}

- (id)proxyForJson {
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	[dict setValue:[NSNumber numberWithLong:uid] forKey:@"id"];
	[dict setValue:[NSNumber numberWithLong:version] forKey:@"version"];
	return dict;
}
@end
