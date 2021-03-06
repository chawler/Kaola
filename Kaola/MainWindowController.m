//
//  MainWindowController.m
//  Kaola
//
//  Created by shendou on 14-7-11.
//  Copyright (c) 2014年 shendou. All rights reserved.
//

#import "MainWindowController.h"

#import "ASIHTTPRequest.h"

#import "Program.h"
#import "AudioStreamer.h"
#import "DOUAudioStreamer.h"

#import "LZWCompressor.h"

@implementation MainWindowController
{
    ASIHTTPRequest *_request;
    AudioStreamer  *_streamer;
//    DOUAudioStreamer *_streamer;

    NSTimer        *_progressUpdateTimer;
    NSArray        *_programList;
    NSString       *_currentPlayURL;
    NSInteger       _currentPlayIndex;
    
    BOOL            _pressToStop;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
//        NSMutableArray *arr = [NSMutableArray array];
//        LZWCompressor *lzw = [[LZWCompressor alloc] initWithArray:arr];
//        if (lzw) {
//            [lzw compressData:[@"http://v2.kaolafm.com/KAOLA_PHONE/programInfo?mediaId=31,227,424626&page=3" dataUsingEncoding:NSUTF8StringEncoding]];
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[lzw getArray]];
//            for ( id obj in arr )
//            {
//                printf("%u", [obj unsignedIntValue]);
//            }
//            printf("\n");
//        }
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://v2.kaolafm.com/KAOLA_PHONE/programInfo?mediaId=31,227,424626&page=1"]];
    _request.delegate = self;
    [_request startAsynchronous];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    float x = pow(2, 0);
    NSInteger b = 0;
    NSArray *arr = @[@(1), @(2), @(1), @(2), @(1)];
    for (int i = 0; i< arr.count; i++ ) {
        if ([arr[i] integerValue] == 2) {
            NSInteger a = (1 << (i+1)) - (1 << i);
            b |= a;
        }
    }
    NSLog(@"%ld", b & 8);
//    1
//    2
//    4
//    8
//    16
//    32
//    64
//    128
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    _programList = [Program programsWithXmlData:request.responseData];
    [programTableView reloadData];
//    NSLog(@"%@", _programList);
}

- (IBAction)sliderMoved:(NSSlider *)sender
{
    if (_streamer.duration)
	{
		double newSeekTime = ([sender doubleValue] / 100.0) * _streamer.duration;
		[_streamer seekToTime:newSeekTime];
	}
}

- (IBAction)playPress:(NSButton *)sender
{
    if ([playButton.image isEqual:[NSImage imageNamed:@"playbutton"]])
	{
        _pressToStop = NO;
		[self createStreamer];
		[_streamer start];
	}
	else
	{
        _pressToStop = YES;
		[_streamer stop];
	}
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
    if (_streamer.progress - 0.1 == _streamer.duration) {
        
    }
//    NSLog(@"playing");
    if (_streamer.state == AS_STOPPING) {
        NSLog(@"Stopping");
        float lefttime = _streamer.duration - _streamer.progress;
        if (!_pressToStop) {
            NSLog(@"next one");
            _currentPlayIndex++;
            _currentPlayURL = [self _programForRow:_currentPlayIndex].programPlayURL;
            [self performSelector:@selector(nextone) withObject:nil afterDelay:lefttime];
        }
    }
    else if (_streamer.state == AS_STOPPED) {
        NSLog(@"Stopped");
    }
	else if ([_streamer isWaiting]) {
        playButton.image = [NSImage imageNamed:@"pausebutton"];
	}
	else if ([_streamer isPlaying]) {
        if (!_progressUpdateTimer) {
            _progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
        }
        playButton.image = [NSImage imageNamed:@"stopbutton"];
	}
	else if ([_streamer isIdle]) {
		[self destroyStreamer];
        playButton.image = [NSImage imageNamed:@"playbutton"];
	}
}

- (void)nextone
{
    [programTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:_currentPlayIndex] byExtendingSelection:NO];
    [programTableView scrollRowToVisible:_currentPlayIndex];
    [self createStreamer];
    [_streamer start];
}

- (void)createStreamer
{
    if (!_currentPlayURL) return;
	if (_streamer)
	{
		_streamer = nil;
	}
    
	[self destroyStreamer];
	
	NSURL *url = [NSURL URLWithString:_currentPlayURL];
	_streamer = [[AudioStreamer alloc] initWithURL:url];
	
//	_progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:ASStatusChangedNotification
                                               object:_streamer];
}

- (void)destroyStreamer
{
	if (_streamer)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:ASStatusChangedNotification
                                                      object:_streamer];
		[_progressUpdateTimer invalidate];
		_progressUpdateTimer = nil;
		
		[_streamer stop];
		_streamer = nil;
	}
}

//- (void)_resetStreamer
//{
//    [self _cancelStreamer];
//    
//    if (0 == [_tracks count])
//    {
//        [_miscLabel setText:@"(No tracks available)"];
//    }
//    else
//    {
//        Track *track = [_tracks objectAtIndex:_currentTrackIndex];
//        NSString *title = [NSString stringWithFormat:@"%@ - %@", track.artist, track.title];
//        [_titleLabel setText:title];
//        
//        _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
//        [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
//        [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
//        [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
//        
//        [_streamer play];
//        
//        [self _updateBufferingStatus];
//        [self _setupHintForStreamer];
//    }
//}

- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (_streamer.bitRate != 0.0)
	{
		int progress = _streamer.progress;
		int duration = _streamer.duration;
		
		if (duration > 0)
		{
//			[positionLabel setStringValue:
//             [NSString stringWithFormat:@"%d/%d",
//              progress,
//              duration]];
            [positionLabel setStringValue:[NSString stringWithFormat:@"%02d:%02d/%02d:%02d", progress/60, progress%60, duration/60, duration%60]];
			[progressSlider setEnabled:YES];
			[progressSlider setDoubleValue:100 * progress / duration];
		}
		else
		{
			[progressSlider setEnabled:NO];
		}
	}
	else
	{
		[positionLabel setStringValue:@"Time Played:"];
	}
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _programList.count;
}

- (Program *)_programForRow:(NSInteger)row
{
    return (Program *)[_programList objectAtIndex:row];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Program *program = [self _programForRow:row];
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"ProgramCell" owner:self];
    cellView.textField.stringValue = [NSString stringWithFormat:@"第%d期  %@", program.whichPeriod, program.programName];
    return cellView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 20;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    NSLog(@"click");
//    NSURL *url = [NSURL URLWithString:[self _programForRow:row].programPlayURL];
//	_streamer = [[AudioStreamer alloc] initWithURL:url];
//    [_streamer start];
    _currentPlayIndex = row;
    _currentPlayURL = [self _programForRow:row].programPlayURL;
    return YES;
}

@end
