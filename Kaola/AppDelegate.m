//
//  AppDelegate.m
//  Kaola
//
//  Created by shendou on 14-7-11.
//  Copyright (c) 2014年 shendou. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _mainWindow = [[MainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    [_mainWindow showWindow:self];
}

@end
