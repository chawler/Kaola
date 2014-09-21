//
//  Program.h
//  Kaola
//
//  Created by shendou on 14-7-11.
//  Copyright (c) 2014年 shendou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RXMLElement.h"
#import "DOUAudioFile.h"

@interface Program : NSObject <DOUAudioFile>

@property (nonatomic, copy) NSString *hostNames;
@property (nonatomic, assign) int whichPeriod;
@property (nonatomic, copy) NSString *programName;
@property (nonatomic, assign) int duration;
@property (nonatomic, copy) NSString *programPlayURL;
@property (nonatomic, assign) int isHeard;
@property (nonatomic, assign) int programID;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *programDescription;

+ (id)programsWithXmlData:(NSData *)data;
+ (NSArray *)programWithRXmlElement:(RXMLElement *)element;

@end
