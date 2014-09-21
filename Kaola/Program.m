//
//  Program.m
//  Kaola
//
//  Created by shendou on 14-7-11.
//  Copyright (c) 2014年 shendou. All rights reserved.
//

#import "Program.h"

@implementation Program

+ (id)programWithRXmlElement:(RXMLElement *)element
{
    Program *program = [Program new];
    program.hostNames = [element child:@"HostNames"].text;
    program.whichPeriod = [element child:@"WhichPeriod"].textAsInt;
    program.programName = [element child:@"ProgramName"].text;
    program.duration = [element child:@"Duration"].textAsInt;
    program.programPlayURL = [element child:@"ProgramPlayURL"].text;
    program.isHeard = [element child:@"IsHeard"].textAsInt;
    program.programID = [element child:@"ProgramID"].textAsInt;
    program.shareURL = [element child:@"ShareURL"].text;
    program.programDescription = [element child:@"ProgramDescription"].text;
    return program;
}

+ (NSArray *)programsWithXmlData:(NSData *)data
{
    NSMutableArray *arr = [NSMutableArray array];
    for (RXMLElement *element in [[[RXMLElement elementFromXMLData:data] child:@"ProgramsList"] children:@"Program"]) {
        [arr addObject:[self programWithRXmlElement:element]];
    }
    return arr;
}

- (NSURL *)audioFileURL
{
    return [NSURL URLWithString:self.programPlayURL];
}

@end
