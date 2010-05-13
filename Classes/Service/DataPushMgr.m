//
//  DataPushMgr.m
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataPushMgr.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "GameLogMgrPool.h"

static DataPushMgr* sharedInstance = nil;

@interface DataPushMgr(private) 
- (void) addToUnsentEvents: (long) gameId: (NSArray*) events;

@end

@implementation DataPushMgr

@synthesize pushEventsURL;
@synthesize unsentEventsMap;

// singleton methods
+ (DataPushMgr*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[DataPushMgr alloc] init];
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


- (void)startService{
	[NSThread detachNewThreadSelector:@selector(push:) toTarget:[DataPushMgr sharedInstance] withObject:nil];
}


+(void) initialize {
	DataPushMgr *instance = [DataPushMgr sharedInstance];
	[instance startService];
}

-(id) init {
	if (self = [super init]) {
		[self setPushEventsURL: @"http://localhost:8080/ulticast/game/%@"];	
		[self setUnsentEventsMap: [NSMutableDictionary dictionary]];
	}
	return self;
}


/**
 * run loop that pings the gameLogMgrs for unsent events and form posts to server
 */
-(void) push:(id)obj {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	/*
	 TODO
	 - post all event data
	 - posting multiple events
	 */
	NSURL *url = [NSURL URLWithString:@"http://localhost:8080/ulticast/event/saveEvents"];
	while(YES) {
		NSLog(@"Trying to push...");
		@synchronized(unsentEventsMap) {
			NSNumber *gameId;
			for (gameId in unsentEventsMap) {
				NSLog(@"Pushing for gameId : %@", gameId);
				NSMutableArray* events = [unsentEventsMap objectForKey:gameId];
				NSLog(@"events: %@", events);
				@try {
					if ([events count] != 0) {
							ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
							NSLog(@"Posting event : %@", [events JSONRepresentation]);
						
							[request setPostValue:gameId forKey:@"gameId"];
							[request setPostValue:[events JSONRepresentation] forKey:@"eventList"];
							[request startSynchronous];  // TODO make asychronous
							NSError *error = [request error];
							if (error != nil || [request responseStatusCode] != 200) {
								NSString *response = [request responseString];
								NSLog(@"Error code: %d : %@", [request responseStatusCode], response);
								// don't clear events list.  retry later
							} else {
								NSString *response = [request responseString];
								NSLog(@"response : %@", response);
								
								[events removeAllObjects]; 
							} // what if there is an error?  keep trying...																						
					}
				}
				@catch (NSException * exception) {
					NSLog(@"caught %@: %@, adding unsent events : %@ for gameId : %d", [exception name], [exception reason], events, gameId);
					// add to unsent events queue. try again next time.
				}
			}
		}
			
		usleep(6000000);
	}
	[pool release];
}

- (void) addToUnsentEvents: (long) gameId: (NSArray*) events {
	@synchronized (unsentEventsMap) {
		NSMutableArray* unsentEvents = [unsentEventsMap objectForKey:[NSNumber numberWithLong:gameId]];
		if (unsentEvents == nil) {
			unsentEvents = [NSMutableArray arrayWithCapacity:[events count]];
			[unsentEventsMap setObject:unsentEvents forKey:[NSNumber numberWithLong:gameId]];
		}
		[unsentEvents addObjectsFromArray:events];
	}
}

- (void) sendEvent:(long) gameId: (GameEvent*) event {
	[self addToUnsentEvents:gameId : [NSArray arrayWithObject:event]];	
}


@end
