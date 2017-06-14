//
//  DateModel.h
//  时间
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 xiaocao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  enum
{
    DateModelTypeDays =0,
    DateModelTypeWeeks = 1,
    DateModelTypeMonths = 2,
    DateModelTypeYears = 3,
    
}DateModelType;

@interface DateModel : NSObject
//用法说明
/**
 NSDate *now = [NSDate date];
 
 NSDate *demoDate = [CGFDateModifier dateByModifiyingDate:now withModifier:@"+ 1 week"];
 NSLog(@"%@", demoDate);
 
 demoDate = [CGFDateModifier dateByModifiyingDate:now withModifiers:@[@"+ 1 week", @"- 2 days"]];
 NSLog(@"%@", demoDate);
 **/
/**
    首位不能为空，否者都为加！！！
  + 号代表加往后加  - 代表往前减
 **/

//[NSDate dateByModifiyingDate:[NSDate date] withModifier:@"-1 week"]

+ (NSDate*) dateByModifiyingDate:(NSDate*)date withModifier:(NSString*)modifier;

//[NSDate dateByModifiyingDate:[NSDate date] withModifiers:[NSArray arrayWithObjects:@"+1 week", @"+4 days", nil]]

+ (NSDate*) dateByModifiyingDate:(NSDate*)date withModifiers:(NSArray*)modifiers;
@end
