//
//  SelectMenuItem.h
//  RestApp
//
//  Created by zxh on 14-5-26.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INameValueItem.h"
@class SampleMenuVO;
@interface SelectMenuItem : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong,nonatomic) SampleMenuVO* item;

-(void) loadItem:(SampleMenuVO*)data;
-(void)loadData:(id<INameValueItem>)data;

@end
