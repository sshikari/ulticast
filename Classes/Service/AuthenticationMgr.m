//
//  AuthenticationMgr.m
//  ulticast
//
//  Created by Richard Chang on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AuthenticationMgr.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"

//NSString *const AUTH_KEY = @"AUTH_KEY";
NSString *const AUTH_MGR_KEY = @"AUTH_MGR_KEY";

static AuthenticationMgr* sharedInstance = nil;

@interface AuthenticationMgr()
@property (nonatomic, retain) NSString* authKey;   
@end


@implementation AuthenticationMgr

@synthesize username;
@synthesize player;
@synthesize authKey;

// singleton methods
+ (AuthenticationMgr*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil) {
			// check defaults if mgr was saved before
			NSData* savedMgr = [[NSUserDefaults standardUserDefaults] objectForKey: AUTH_MGR_KEY];
			if (savedMgr != nil) {
				sharedInstance = (AuthenticationMgr*) [NSKeyedUnarchiver unarchiveObjectWithData:savedMgr];
			} else {
				sharedInstance = [[AuthenticationMgr alloc] init];
			}
		}
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


- (void) saveUserInfo {
	if ([self isLoggedIn]) {
		NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:sharedInstance];
		[[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:AUTH_MGR_KEY];
	}
}

- (long) userPlayerId {
	return player.playerId;
}

- (BOOL) isLoggedIn {
	return authKey.length != 0;	
}
- (BOOL) logout {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:AUTH_MGR_KEY];
	[username release];
	[authKey release];
	[player release];
	username = nil;
	authKey = nil;
	player = nil;
	return YES;
}

- (BOOL) login: (NSString*) user: (NSString*) password {
	[self setUsername: user];
	
	// login at server, get auth key back
	// save key in keystore		
	NSURL *loginURL = [NSURL URLWithString:@"http://localhost:8080/testapp/login"];	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:loginURL];
	[request setPostValue:[self username] forKey:@"username"];
	[request setPostValue:password forKey:@"password"];
	[request startSynchronous];  // TODO make asychronous
	NSError *error = [request error];	 
	if (error != nil || [request responseStatusCode] != 200) {
		NSString *response = [request responseString];
		NSLog(@"Error code: %d : %@", [request responseStatusCode], response);
		return NO;			
	} else {		
		NSString *response = [request responseString];		
		SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
		NSDictionary* jsonObject = [jsonParser objectWithString:response];
		NSLog(@"response : %@\n", response);
		NSLog(@"object : %@\n", jsonObject);

 		NSString* aKey = @"test_auth_key";
		Player *playr = [[Player alloc] initFromDictionary:jsonObject];
		[self setPlayer: playr];
		[self setAuthKey:aKey];
		
		[playr release];
		[jsonParser release];
		return YES;
	} 
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:username forKey:@"username"];
	[aCoder encodeObject:player forKey:@"player"];
	[aCoder encodeObject:authKey forKey:@"authKey"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	username = [[aDecoder decodeObjectForKey:@"username"] retain];
	player = [[aDecoder decodeObjectForKey:@"player"] retain]; 
	authKey = [[aDecoder decodeObjectForKey:@"authKey"] retain]; 
	return self;
}


@end
