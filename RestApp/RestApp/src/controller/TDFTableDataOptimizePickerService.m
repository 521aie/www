//
//  TDFTableDataOptimizePickerService.m
//  RestApp
//
//  Created by LSArlen on 2017/6/13.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFTableDataOptimizePickerService.h"
#import "TDFShowPickerStrategy.h"
#import "NameItemVO.h"
#import "TDFPickerItem.h"
#import "TDFShowDatePickerStrategy.h"
#import "TDFTableDataOptimizeStringFormater.h"

@interface TDFTableDataOptimizePickerService() <TDFPickerStrategyDelegate>

@property (nonatomic, weak) TDFPickerItem *pickerItem;

@property (nonatomic, strong) TDFShowPickerStrategy *showPickerStrategy;
@property (nonatomic, strong) TDFShowDatePickerStrategy *dateStrategy;


@property (nonatomic, strong) NSMutableArray  *OptimizeMethodItems;
@property (nonatomic, strong) NSMutableArray  *OptimizeBillTypeItems;
@property (nonatomic, strong) NSMutableArray *optimizeBillDays;
@property (nonatomic, strong) NSMutableArray *optimizeBillPers;

@end

@implementation TDFTableDataOptimizePickerService


- (instancetype)initWith:(TDFPickerItem *)pickerItem {
    self = [super init];
    if (self) {
        self.pickerItem = pickerItem;
    }
    return self;
}

- (void)setPickerType:(TDFTableDataOptimizePickerType)pickerType {
    _pickerType = pickerType;
    switch (pickerType) {
            case TDFTableDataOptimizePickerTypePer: {
                self.pickerItem.strategy = self.showPickerStrategy;
                self.showPickerStrategy.pickerItemList  =   self.optimizeBillPers;
                self.showPickerStrategy.pickerName           =   [self.pickerItem.title substringFromIndex:2];
        }
            break;
            
            case TDFTableDataOptimizePickerTypeNumDay: {
                self.pickerItem.strategy = self.showPickerStrategy;
                self.showPickerStrategy.pickerItemList  =   self.optimizeBillDays;
                self.showPickerStrategy.pickerName           =   @"自动优化前几天的账单（天）";
        }
            break;
            
            case TDFTableDataOptimizePickerTypeEndDate: {
            self.pickerItem.strategy = self.dateStrategy;
            self.dateStrategy.pickerName = @"选择结束日期";
        }
            break;
            
            case TDFTableDataOptimizePickerTypeBillType: {
            self.pickerItem.strategy = self.showPickerStrategy;
            self.showPickerStrategy.pickerItemList  =   self.OptimizeBillTypeItems;
            self.showPickerStrategy.pickerName           =   @"优化账单类型";
        }
            break;
            
            case TDFTableDataOptimizePickerTypeStartDate: {
            self.pickerItem.strategy = self.dateStrategy;
            self.dateStrategy.pickerName = @"选择开始日期";
        }
            break;
            
            case TDFTableDataOptimizePickerTypeOptimizeMethod: {
            self.pickerItem.strategy = self.showPickerStrategy;
            self.showPickerStrategy.pickerItemList = self.OptimizeMethodItems;
             self.showPickerStrategy.pickerName     =   @"数据优化方式";
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)strategyCallbackWithTextValue:(NSString *)textValue requestValue:(id)requestValue {
    return self.pickerItem.filterBlock(textValue, requestValue);
}


- (TDFShowPickerStrategy *)showPickerStrategy {
    if (!_showPickerStrategy) {
        _showPickerStrategy = [[TDFShowPickerStrategy alloc] init];
        _showPickerStrategy.delegate    =   self;
    }
    return _showPickerStrategy;
}


- (TDFShowDatePickerStrategy *)dateStrategy {
    if (!_dateStrategy) {
        _dateStrategy = [[TDFShowDatePickerStrategy alloc] init];
        _dateStrategy.mode  =   UIDatePickerModeDate;
        _dateStrategy.format= @"YYYY-MM-dd";
        _dateStrategy.delegate = self;
        _dateStrategy.maxinumDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
    }
    return _dateStrategy;
}


- (NSMutableArray *)OptimizeMethodItems {
    if (!_OptimizeMethodItems) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:[TDFTableDataOptimizeStringFormater stringByMethodType:0] andId:@"0"];
        [array addObject:item];
        
        item = [[NameItemVO alloc] initWithVal:[TDFTableDataOptimizeStringFormater stringByMethodType:1] andId:@"1"];
        [array addObject:item];
        _OptimizeMethodItems = [array mutableCopy];
    }
    return _OptimizeMethodItems;
}

- (NSMutableArray *)OptimizeBillTypeItems {
    if (!_OptimizeBillTypeItems) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        NameItemVO *item = [[NameItemVO alloc] initWithVal:[TDFTableDataOptimizeStringFormater  stringByBillOptimizeType:0] andId:@"0"];
        [array addObject:item];
        item = [[NameItemVO alloc] initWithVal:[TDFTableDataOptimizeStringFormater stringByBillOptimizeType:1] andId:@"1"];
        [array addObject:item];
        _OptimizeBillTypeItems = [array mutableCopy];
    }
    return _OptimizeBillTypeItems;
}

- (NSMutableArray *)optimizeBillDays {
    if (!_optimizeBillDays) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 60; i++) {
            NSString *day = [NSString stringWithFormat:@"%d",i+1];
            NameItemVO *item = [[NameItemVO alloc] initWithVal:day andId:day];
            [array addObject:item];
        }
        _optimizeBillDays = [array mutableCopy];
    }
    return _optimizeBillDays;
}

- (NSMutableArray *)optimizeBillPers {
    if (!_optimizeBillPers) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 100; i++) {
            NSString *per = [NSString stringWithFormat:@"%d",i+1];
            NameItemVO *item = [[NameItemVO alloc] initWithVal:per andId:per];
            [array addObject:item];
        }
        _optimizeBillPers = [array mutableCopy];
    }
    return _optimizeBillPers;
}


- (void)setDefaultIndex:(int)defaultIndex {
    _defaultIndex = defaultIndex;
    switch (self.pickerType) {
        case TDFTableDataOptimizePickerTypeOptimizeMethod: {
            self.showPickerStrategy.selectedItem = self.OptimizeMethodItems[defaultIndex];
        }
            break;
        case TDFTableDataOptimizePickerTypeBillType: {
            self.showPickerStrategy.selectedItem = self.OptimizeBillTypeItems[defaultIndex];
        }
            break;
        default:
            break;
    }
}

@end
























