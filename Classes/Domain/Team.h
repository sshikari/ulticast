//
//  Team.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "DomainObject.h"

@interface Team : DomainObject {
	NSString* name;
	BOOL myTeam;
	// Location *location;
	NSArray* players;
}

- (id) initWithName: (NSString*) n;

- (NSArray*) playerNames;
		
@property BOOL myTeam;
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSArray* players;

- (Player*) playerAtIndex: (int) i;
- (id)proxyForJson;
@end
