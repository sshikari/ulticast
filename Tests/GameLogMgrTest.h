//
//  GameLogMgrTest.h
//  MyTabBar-BAK2
//
//  Created by Richard Chang on 4/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 1

#import "GTMSenTestCase.h"
#import <UIKit/UIKit.h>
//#import "GameLogMgr.h"
#import "ScoreEvent.h"
//#import "application_headers" as required


@interface GameLogMgrTest : GTMTestCase {

}

- (void) testSomething;              // simple standalone test

@end
