//
//  DataPushMgr.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameEvent.h"


@interface DataPushMgr : NSObject {
	
	NSString* pushEventsURL;
	NSMutableDictionary* unsentEventsMap;
}

+ (DataPushMgr*)sharedInstance;

- (void) sendEvent:(long) gameId: (GameEvent*) event;

@property (retain, nonatomic) NSString* pushEventsURL;
@property (retain, nonatomic) NSMutableDictionary* unsentEventsMap;

@end
