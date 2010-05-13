//
//  ReferenceDataMgr.m
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ReferenceDataMgr.h"
#import "Team.h"
#import "GameLocation.h"
#import "AuthenticationMgr.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "Utils.h"


static ReferenceDataMgr* sharedInstance = nil;
static NSArray *WIND_OPTIONS;
static NSArray *WEATHER_OPTIONS;

@interface ReferenceDataMgr (private)
- (void) updateTeams;	

@end


@implementation ReferenceDataMgr

@synthesize currentUsersTeams;
@synthesize currentOpponentsTeams;
@synthesize lastUpdated;

+ (void) initialize {
	WEATHER_OPTIONS = [[NSArray arrayWithObjects: @"Sunny", @"Cloudy", @"Rainy", nil ] retain];
	WIND_OPTIONS = [[NSArray arrayWithObjects: @"Downwind", @"Upwind", nil] retain];	
}

// singleton methods
+ (ReferenceDataMgr*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[ReferenceDataMgr alloc] init];
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

-(id) init {
	if (self = [super init]) {
	}
	return self;
}

- (NSArray*) myTeams {
	[self updateTeams];
	return currentUsersTeams;
}

- (void) updateTeams {
		// get user's teams and then opponent teams	
		NSURL *feedURL = [NSURL URLWithString:@"http://localhost:8080/ulticast/team/feed"];
		long playerId = [[AuthenticationMgr sharedInstance] userPlayerId];
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:feedURL];
	 	[request setPostValue:[NSNumber numberWithInt: playerId] forKey:@"id"];
		[request startSynchronous];  // TODO make asychronous
		NSError *error = [request error];
		if (error != nil || [request responseStatusCode] != 200) {
			NSString *response = [request responseString];
			NSLog(@"Error code: %d : %@", [request responseStatusCode], response);
			// TODO exception thrown that triggers alert view?
		} else {
			NSString *response = [request responseString];
			SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
			NSDictionary* jsonObject = [jsonParser objectWithString:response];
			NSLog(@"response : %@\n", response);
			NSLog(@"object : %@\n", jsonObject);
			// expecting map:
			// myTeams -> List of teams, should include players
			// opponents -> list of teams
			NSArray* myTeamsArray = [jsonObject objectForKey: @"myTeams"];
			NSArray* myTeamsConverted = [Utils fromJSON: myTeamsArray: [Team class]];
			[self setCurrentUsersTeams:myTeamsConverted];
			
			NSArray* myOpponentsArray = [jsonObject objectForKey: @"opponents"];
			NSArray* myOpponentsConverted = [Utils fromJSON: myOpponentsArray: [Team class]];
			[self setCurrentOpponentsTeams: myOpponentsConverted];
		}
	
	
}
- (NSArray*) teams {
//	Player *bill = [[Player alloc] initWith: 21: @"Bill"];
//	Player *hillary = [[Player alloc] initWith: 22: @"Hillary"];	
//	Player *blake = [[Player alloc] initWith: 11: @"Blake"];
//	Player *rich = [[Player alloc] initWith: 12: @"Rich"];
//	
//	Team *harvard = [[Team alloc] initWithName:@"Harvard"];
//	Team *tufts = [[Team alloc] initWithName:@"Tufts"];
//	NSArray* hPlayers = [NSArray arrayWithObjects:bill, hillary, 
//						 [[Player alloc] initWith: 23: @"P23"],
//						 [[Player alloc] initWith: 24: @"P24"],
//						 [[Player alloc] initWith: 25: @"P25"],
//						 [[Player alloc] initWith: 26: @"P26"],
//						 [[Player alloc] initWith: 27: @"P27"],
//						 nil];
//	NSArray* tPlayers = [NSArray arrayWithObjects:rich, blake, 
//						 [[Player alloc] initWith: 13: @"P13"],
//						 [[Player alloc] initWith: 14: @"P14"],
//						 [[Player alloc] initWith: 15: @"P15"],
//						 [[Player alloc] initWith: 16: @"P16"],
//						 [[Player alloc] initWith: 17: @"P17"],
//						 nil];
//	[tufts setPlayers: tPlayers];
//	[harvard setPlayers: hPlayers];
//	
//	NSArray* teams = [NSArray arrayWithObjects: harvard, tufts, nil];
//	[harvard release];
//	[tufts release];
	return currentOpponentsTeams;
}

- (NSArray*) locations {
	return [NSArray arrayWithObjects: [[GameLocation alloc] initWithDesc: @"Tufts turf field"],
							   [[GameLocation alloc] initWithDesc: @"Harvard yard"], 
							   [[GameLocation alloc] initWithDesc: @"Central Park, Sheepshead Meadow"], 
								nil];
}	


//TODO
//-- equals methods on objects so check box is shown when selection is already slected
//--
- (NSArray*) weatherOptions {
	return WEATHER_OPTIONS;
}

- (NSArray*) windOptions {
	return WIND_OPTIONS;
}

@end
