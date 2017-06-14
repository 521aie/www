//
//  SuitMenuChange.h
//  RestApp
//
//  Created by zxh on 14-8-22.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "BaseSuitMenuChange.h"
#import "INameItem.h"
#import "INameValueItem.h"

@interface TDFSuitMenuChangeSuitMenuChangeExtra :NSObject
@property (nonatomic, assign)int limit_num;
@end

@interface SuitMenuChange : BaseSuitMenuChange<INameItem,INameValueItem>

@property (nonatomic,retain) NSString * menuName;
@property double menuPrice;
@property (nonatomic,retain) NSString * specDetailName;

/**
 * <code>是否必选(必选/备选)</code>.
 */
@property short isRequired;

@property (nonatomic, strong)TDFSuitMenuChangeSuitMenuChangeExtra *suitMenuChangeExtra;
@end

