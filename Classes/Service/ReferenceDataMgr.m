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
#import "Env.h"
#import "JSON.h"

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
	    NSURL *feedURL = [NSURL URLWithString:[NSString stringWithFormat: @"%@/api/team/all", [[Env sharedInstance] hostURL]]];

	    /*
		   /overview?token=
		   /all?token=      - only my teams
				- isMyTeam
				
		   /detail?token, id
		   /update token, id
		   /new
		   /delete
		 */
	

    	NSLog(@"token: %@", [[AuthenticationMgr sharedInstance] authKey]);
		ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:feedURL];
    	[request setPostValue:[[AuthenticationMgr sharedInstance] authKey] forKey:@"token"];
		[request startSynchronous];
    	NSDictionary *dataMap = [Utils requestDataMap:request];
    	NSError* error = [dataMap objectForKey:@"error"];
      	if (error) {
			NSLog(@"%@", error);
			NSDictionary *userInfo = [error userInfo];
			NSLog(@"%@", [userInfo objectForKey:@"errorString"]);
			return;			
		} else {
			NSArray* teams = [dataMap objectForKey: @"teams"];
			NSArray* teamsConverted = [Utils fromJSON: teams: [Team class]];
			NSMutableArray * myTeams = [NSMutableArray array];
			NSMutableArray * oppTeams = [NSMutableArray array];

			for (Team *team in teamsConverted) {
				if ([team myTeam]) {
					[myTeams addObject:team];	
				} else {
					[oppTeams addObject:team];
				}
			}
			[self setCurrentUsersTeams:myTeams];
			[self setCurrentOpponentsTeams:oppTeams];
		}
}
- (NSArray*) teams {
	return currentOpponentsTeams;
}

- (NSArray*) locations {
	return [NSArray arrayWithObjects: [[GameLocation alloc] initWithDesc: @"Tufts turf field"],
							   [[GameLocation alloc] initWithDesc: @"Harvard yard"], 
							   [[GameLocation alloc] initWithDesc: @"Central Park, Sheepshead Meadow"], 
								nil];
}	

- (void) deleteTeam: (Team*) team : (NSError**) didFail {
	NSURL *feedURL = [[Env sharedInstance] teamDeleteURL]; 
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:feedURL];
	[request setPostValue:[[AuthenticationMgr sharedInstance] authKey] forKey:@"token"];
	[request setPostValue: [NSNumber numberWithLong: team.uid] forKey:@"id"];
	[request setPostValue: [NSNumber numberWithLong: team.version] forKey:@"version"];
	[request startSynchronous];
	NSDictionary *dataMap = [Utils requestDataMap:request];
	NSError* error = [dataMap objectForKey:@"error"];
	if (error) {
		*didFail = error;
	} 
}

- (void) addTeam: (Team*) team : (NSError**) didFail {
	BOOL newTeam = team.uid <= 0;
	NSURL *feedURL = newTeam 
						? [[Env sharedInstance] teamAddURL] 
					    : [[Env sharedInstance] teamUpdateURL];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:feedURL];
	[request setPostValue:[[AuthenticationMgr sharedInstance] authKey] forKey:@"token"];
	if (!newTeam) {
		[request setPostValue: [NSNumber numberWithLong: team.uid] forKey:@"id"];
		[request setPostValue: [NSNumber numberWithLong: team.version] forKey:@"version"];
	}
	[request setPostValue:team.name forKey:@"name"];
	[request setPostValue:[NSNumber numberWithBool:team.myTeam] forKey:@"is_my_team"];
	NSArray* players = [team players];
	if (players != nil && players.count != 0) {
		NSLog(@"%@", [players JSONRepresentation]);
		[request setPostValue:[players JSONRepresentation] forKey:@"players"];
	} 
	//else {
	//	[request setPostValue: [NSNumber numberWithBool:YES] forKey:@"no_player_update"];
	//}
			
	[request startSynchronous];
	NSDictionary *dataMap = [Utils requestDataMap:request];
	NSError* error = [dataMap objectForKey:@"error"];
	if (error) {
		*didFail = error;
	} else {
		long newId = [[[dataMap objectForKey:@"team"] objectForKey:@"id"] longValue];
		int version = [[[dataMap objectForKey:@"team"] objectForKey:@"version"] intValue]; 
		[team setUid:newId];
		[team setVersion:version];
	}
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
