//
//  ShopBlackListView.h
//  RestApp
//
//  Created by 刘红琳 on 15/9/2.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameValueListView.h"
#import "KabawModule.h"
#import "KabawService.h"
#import "ISampleListEvent.h"

@interface ShopBlackListView : NameValueListView<ISampleListEvent>
{
    
    NSMutableArray *arr1;
    
    NSInteger row;
    
    UIView *bgView;
}
-(void)loadDatas;

@end
