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
#import "Env.h"
#import "Utils.h"

NSString *const AUTH_MGR_KEY = @"AUTH_MGR_KEY";


static AuthenticationMgr* sharedInstance = nil;

@interface AuthenticationMgr()
@end


@implementation AuthenticationMgr

@synthesize username;
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


- (BOOL) isLoggedIn {
	return authKey.length != 0;	
}
- (BOOL) logout {
	NSURL *loginURL = [NSURL URLWithString:[NSString stringWithFormat: @"%@/api/logout", [[Env sharedInstance] hostURL]]];	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:loginURL];
	[request setPostValue:[self authKey] forKey:@"token"];
	[request startSynchronous];
	// TODO if logout fails, should we try again?
	NSDictionary* dataMap = [Utils requestDataMap:request];
	if (dataMap == nil)
		return NO;
		
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:AUTH_MGR_KEY];
	[username release];
	[authKey release];
	username = nil;
	authKey = nil;
	
	
	return YES;
}

- (BOOL) login: (NSString*) user: (NSString*) password {
	[self setUsername: user];
	
	// login at server, get auth key back
	// save key in keystore		
	NSURL *loginURL = [NSURL URLWithString:[NSString stringWithFormat: @"%@/api/login", [[Env sharedInstance] hostURL]]];	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:loginURL];
	[request setPostValue:[self username] forKey:@"username"];
	[request setPostValue:password forKey:@"password"];
	[request startSynchronous];
	
	NSDictionary* dataMap = [Utils requestDataMap:request];
	NSError *error = [dataMap objectForKey:@"error"];
	if (error)
		return NO;
	
	NSString* aKey = [dataMap objectForKey:@"token"];	
	NSLog(@"Token : %@", aKey);					
	[self setAuthKey:aKey];
	[self saveUserInfo];
	return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:username forKey:@"username"];
	[aCoder encodeObject:authKey forKey:@"authKey"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	username = [[aDecoder decodeObjectForKey:@"username"] retain];
	authKey = [[aDecoder decodeObjectForKey:@"authKey"] retain]; 
	return self;
}


@end
