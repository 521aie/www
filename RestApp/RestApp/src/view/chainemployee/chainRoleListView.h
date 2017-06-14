//
//  chainRoleListView.h
//  RestApp
//
//  Created by iOS香肠 on 16/2/25.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "NameValueListView.h"

@interface chainRoleListView : NameValueListView <ISampleListEvent>
@property (nonatomic,copy) void (^roleEditCallBack)(BOOL orRefresh);
@property (nonatomic,retain) NSMutableArray *roleList;
@property (nonatomic,strong) NSString *entityId;
@property (nonatomic, strong) NSString *type;

@end
