//
//  SuitMenuRender.m
//  RestApp
//
//  Created by zxh on 14-8-27.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SuitMenuRender.h"
#import "Base.h"
#import "NameItemVO.h"
#import "Platform.h"
#import "RestConstants.h"
@implementation SuitMenuRender
{
    BOOL _version;
}
+(NSMutableArray*) listDetailKind
{
    NSMutableArray* vos=[NSMutableArray array];
    NameItemVO *item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"允许顾客自选", nil) andId:[NSString stringWithFormat:@"%d",BASE_FALSE]];
    [vos addObject:item];
    
    item=[[NameItemVO alloc] initWithVal:NSLocalizedString(@"必须全部选择", nil) andId:[NSString stringWithFormat:@"%d",BASE_TRUE]];
    [vos addObject:item];
    
    return vos;
}


- (NSMutableArray *)countArray
{
    if (!_countArray) {
        _countArray = [NSMutableArray array];
        [self initData];
    }else
    {
        if (_version != [[[Platform Instance] getkey:VERSION] boolValue]) {
            [self initData];
        }
    }
    return _countArray;
}

- (void)initData
{
    [_countArray removeAllObjects];
    ///此处 －1 代表不限制，其他的ID 即为value
    _version = [[[Platform Instance] getkey:VERSION] boolValue];
    if (_version) {
        NameItemVO *item = [[NameItemVO alloc] initWithVal:NSLocalizedString(@"不限制", nil) andId:@"-1"];
        [_countArray addObject:item];
    }
    for (int i = 1; i < 101; i ++) {
        NameItemVO *item = [[NameItemVO alloc] initWithVal:[NSString stringWithFormat:@"%d",i] andId:[NSString stringWithFormat:@"%d",i]];
        [_countArray addObject:item];
    }

}

@end
