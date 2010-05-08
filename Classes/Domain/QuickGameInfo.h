//
//  QuickGameInfo.h
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "GameLocation.h"

@interface QuickGameInfo : NSObject <NSCoding> {
	Team *myTeam;
	Team *opponentTeam;
	GameLocation *location;
	BOOL isHomeGame;
	NSString* weatherDescription;
	NSString* wind;	
}

@property (nonatomic, retain) Team *myTeam;
@property (nonatomic, retain) Team *opponentTeam;
@property (nonatomic, retain) GameLocation *location;
@property BOOL isHomeGame;
@property (nonatomic, retain) NSString* weatherDescription;
@property (nonatomic, retain) NSString* wind;	

@end
