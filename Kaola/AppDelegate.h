//
//  AppDelegate.h
//  Kaola
//
//  Created by shendou on 14-7-11.
//  Copyright (c) 2014年 shendou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong, readonly) MainWindowController *mainWindow;

@end
