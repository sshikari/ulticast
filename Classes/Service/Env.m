//
//  Env.m
//  ulticast
//
//  Created by Richard Chang on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Env.h"


static Env* sharedInstance = nil;


@implementation Env

@synthesize hostURL;

// singleton methods
+ (Env*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[Env alloc] init];
			sharedInstance.hostURL = @"http://localhost:8080/ulticast";
    }
	
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}
// end singleton methods


-(NSURL*) teamAddURL {
	return [NSURL URLWithString:[NSString stringWithFormat: @"%@/api/team/new", hostURL]];	
}

-(NSURL*) teamUpdateURL {
	return [NSURL URLWithString:[NSString stringWithFormat: @"%@/api/team/update", hostURL]];	
}

-(NSURL*) teamDeleteURL {
	return [NSURL URLWithString:[NSString stringWithFormat: @"%@/api/team/delete", hostURL]];		
}
@end
