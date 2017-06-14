//
//  PinyinUtils.m
//  RestApp
//
//  Created by zxh on 14-6-13.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "PinyinUtils.h"
#import "PinyinHelper.h"
#import "NSString+Estimate.h"
#import "HanyuPinyinOutputFormat.h"

@implementation PinyinUtils


+(NSString*)convertToPy:(NSString*)source
{
    if ([NSString isBlank:source]) {
        return nil;
    }
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    NSMutableString *resultPinyinStrBuf = [[NSMutableString alloc] init];
    for (int i = 0; i <  source.length; i++) {
        NSString *mainPinyinStrOfChar = [PinyinHelper getFirstHanyuPinyinStringWithChar:[source characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat];
        if (nil != mainPinyinStrOfChar) {
            [resultPinyinStrBuf appendString:[NSString stringWithFormat:@"%C",[mainPinyinStrOfChar characterAtIndex:0]]];
        }
        else {
            if ([NSString isNotNumAndLetter:[NSString stringWithFormat:@"%C",[source characterAtIndex:i]]]) {
                continue;
            }
            [resultPinyinStrBuf appendFormat:@"%C",[source characterAtIndex:i]];
        }
    }
    return [resultPinyinStrBuf uppercaseString];
}
@end
