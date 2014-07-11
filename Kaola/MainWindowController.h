//
//  MainWindowController.h
//  Kaola
//
//  Created by shendou on 14-7-11.
//  Copyright (c) 2014年 shendou. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIHTTPRequest.h"

@interface MainWindowController : NSWindowController <ASIHTTPRequestDelegate, NSTableViewDelegate, NSTableViewDataSource>
{
    IBOutlet NSSlider *progressSlider;
    IBOutlet NSTableView *programTableView;
    IBOutlet NSButton *playButton;
    IBOutlet NSTextField *positionLabel;
}

- (IBAction)sliderMoved:(NSSlider *)sender;
- (IBAction)playPress:(NSButton *)sender;

@end
