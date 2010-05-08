
//
//  ReferenceDataMgr.h
//  ulticast
//
//  Created by Richard Chang on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ReferenceDataMgr : NSObject {
	NSArray* currentUsersTeams;
	NSArray* currentOpponentsTeams;
	NSDate* lastUpdated;
}

+ (ReferenceDataMgr*) sharedInstance;

- (NSArray*) myTeams;
- (NSArray*) teams;
- (NSArray*) locations;
- (NSArray*) weatherOptions;
- (NSArray*) windOptions;

@property (nonatomic, retain) NSArray* currentUsersTeams;
@property (nonatomic, retain) NSArray* currentOpponentsTeams;

@property (nonatomic, retain) NSDate* lastUpdated;

@end
