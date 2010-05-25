//
//  AuthenticationMgr.h
//  ulticast
//
//  Created by Richard Chang on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

extern NSString *const AUTH_KEY;

@interface AuthenticationMgr : NSObject {
    NSString* username;
	NSString* authKey;

}

+ (AuthenticationMgr*)sharedInstance;
- (BOOL) login: (NSString*) username: (NSString*) password;
- (BOOL) logout;
- (void) saveUserInfo;
- (BOOL) isLoggedIn;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* authKey;   

@end
