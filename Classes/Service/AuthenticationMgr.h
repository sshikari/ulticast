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
	Player* player;

@private
	NSString* authKey;

}

+ (AuthenticationMgr*)sharedInstance;
- (BOOL) login: (NSString*) username: (NSString*) password;
- (BOOL) logout;
- (long) userPlayerId;
- (void) saveUserInfo;
- (BOOL) isLoggedIn;

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) Player* player;

@end
