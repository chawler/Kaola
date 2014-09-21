//
//  LZWCompressor.h
//  Kaola
//
//  Created by Karabu on 14-8-11.
//  Copyright (c) 2014年 shendou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZWCompressor : NSObject
{
@private
    NSMutableArray *iostream;
    NSMutableDictionary *dict;
    NSUInteger codemark;
}

- (id) init;
- (id) initWithArray: (NSMutableArray *) stream;
- (BOOL) compressData: (NSData *) string;
- (void) setArray: (NSMutableArray *) stream;
- (NSArray *) getArray;

@end
