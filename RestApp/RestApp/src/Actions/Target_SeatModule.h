//
//  Target_SeatModule.h
//  RestApp
//
//  Created by zishu on 16/9/8.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Target_SeatModule : NSObject

///桌位列表 .
-(UIViewController *)Action_nativeSeatListView:(NSDictionary *)params;

///桌位编辑
- (UIViewController *)Action_nativeSeatEditView:(NSDictionary *)params;

///区域列表 .
-(UIViewController *)Action_nativeAreaListView:(NSDictionary *)params;

///区域编辑
- (UIViewController *)Action_nativeAreaEditView:(NSDictionary *)params;

@end
