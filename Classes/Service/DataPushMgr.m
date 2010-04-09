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
#import "GameLogMgr.h"

static DataPushMgr* sharedInstance = nil;


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
		[self setPushEventsURL: @"http://localhost:8080/testapp/game/%@"];	
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
	while(YES) {
		NSLog(@"Trying to push...");
//		NSString* gameId = @"2";
//		// Construct a request.
//		NSString *urlString = [NSString stringWithFormat:[self pushEventsURL], gameId];
//		NSURL *url = [NSURL URLWithString:urlString];
//	
//		// Get the contents of the URL as a string, and parse the JSON into Foundation objects.
//		NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//		NSLog(@"return str: %@", jsonString);
//		NSDictionary *results = [jsonString JSONValue];
//		NSLog(@"return json obj: %@", results);	

		NSArray* logMgrs = [GameLogMgr allGameLogMgrs];
		if ([logMgrs count] != 0) {
			for (GameLogMgr* lMgr in logMgrs) {
				NSURL *url = [NSURL URLWithString:@"http://localhost:8080/testapp/event/saveEvents"];
				//ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
				
				long gameId = [lMgr gameId];
				NSLog(@"Pushing for gameId : %d", gameId);
					
				NSArray* events;
				@try {
					events = [lMgr transferUnsent];
					if ([events count] != 0) {
						
					
//						for (GameEvent* gameEvent in events) {
							ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//														
//							/**
//							 - gameId
//							 - event list
//							    - event data - type, teams, players, etc.							 
//							    - some verification key
//							 
//							 */
//							NSLog(@"Posting event : %@", [gameEvent JSONRepresentation]);
//							[request setPostValue:[gameEvent eventType] forKey:@"title"];
//							[request setPostValue:[gameEvent JSONRepresentation] forKey:@"author"];
//							[request startSynchronous];
//							NSError *error = [request error];
//							if (!error) {
//								NSString *response = [request responseString];
//								NSLog(@"response : %@", response);
//							} // what if there is an error?  keep trying...										
//						}	
							NSLog(@"Posting event : %@", [events JSONRepresentation]);
						
							[request setPostValue:[NSNumber numberWithInt: gameId] forKey:@"gameId"];
							[request setPostValue:[events JSONRepresentation] forKey:@"eventList"];
							[request startSynchronous];  // TODO make asychronous
							NSError *error = [request error];
							if (!error) {
								NSString *response = [request responseString];
								NSLog(@"response : %@", response);
							} // what if there is an error?  keep trying...																						
					}				
				}
				@catch (NSException * exception) {
					NSLog(@"caught %@: %@, adding unsent events : %@ for gameId : %d", [exception name], [exception reason], events, gameId);
					// add to unsent events queue. try again next time.
					NSMutableArray* unsentEvents = [unsentEventsMap objectForKey:[NSNumber numberWithLong:gameId]];
					if (unsentEvents == nil) {
						unsentEvents = [NSMutableArray arrayWithCapacity:[events count]];	
					}
					[unsentEvents addObjectsFromArray:events];
					[unsentEventsMap setObject:unsentEvents forKey:[NSNumber numberWithLong:gameId]];
				}
			}
		}
		
		usleep(6000000);
	}
	[pool release];
	
}




@end
