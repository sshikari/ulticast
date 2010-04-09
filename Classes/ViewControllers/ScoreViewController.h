//
//  ScoreViewController.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 3/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameLogMgr.h"

@interface ScoreViewController : UITableViewController {
	GameLogMgr* gameLogMgr;
	
}

- (id) initWithParams:(GameLogMgr*) gMgr;

@property (retain, nonatomic) GameLogMgr* gameLogMgr;
@end
