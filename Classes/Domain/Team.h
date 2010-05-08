//
//  Team.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Team : NSObject<NSCoding, JSONInit> {
	long teamId;
	NSString* name;
	// Location *location;
	NSArray* players;
}

- (id) initWithName: (NSString*) n;

- (BOOL) isMyTeam: (NSString*) name;	
- (NSArray*) playerNames;
		
@property long teamId;
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSArray* players;

- (Player*) playerAtIndex: (int) i;
- (id)proxyForJson;
@end
