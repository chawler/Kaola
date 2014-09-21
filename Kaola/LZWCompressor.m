//
//  LZWCompressor.m
//  Kaola
//
//  Created by Karabu on 14-8-11.
//  Copyright (c) 2014年 shendou. All rights reserved.
//

#import "LZWCompressor.h"
#import <stdio.h>

@implementation LZWCompressor

-(id) init
{
    self = [super init];
    if ( self )
    {
        iostream = nil;
        codemark = 256;
        dict = [[NSMutableDictionary alloc] initWithCapacity: 512];
    }
    return self;
}

-(id) initWithArray: (NSMutableArray *) stream
{
    self = [self init];
    if ( self )
    {
        [self setArray: stream];
    }
    return self;
}

-(void) setArray: (NSMutableArray *) stream
{
    iostream = stream;
}

-(BOOL) compressData: (NSData *) string;
{
    // prepare dict
    for(NSUInteger i=0; i < 256; i++)
    {
        unsigned char j = i;
        NSData *s = [NSData dataWithBytes: &j length: 1];
        dict[s] = @(i);
    }
    
    NSData *w = [NSData data];
    
    for(NSUInteger i=0; i < [string length]; i++)
    {
        NSMutableData *wc = [NSMutableData dataWithData: w];
        [wc appendData: [string subdataWithRange: NSMakeRange(i, 1)]];
        if ( dict[wc] != nil )
        {
            w = wc;
        } else {
            [iostream addObject: dict[w]];
            dict[wc] = @(codemark);
            codemark++;
            w = [string subdataWithRange: NSMakeRange(i, 1)];
        }
    }
    if ( [w length] != 0 )
    {
        [iostream addObject: dict[w]];
    }
    return YES;
}

-(NSArray *) getArray
{
    return iostream;
}

@end
