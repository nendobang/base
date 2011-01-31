//
//  testAppDelegate.h
//  test
//
//  Created by Kanaya Fumihiro on 11/01/31.
//  Copyright 2011 Skip co,.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class testViewController;

@interface testAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    testViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet testViewController *viewController;

@end

