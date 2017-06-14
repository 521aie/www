//
//  NoPrintMenuItemTableViewCell.h
//  RestApp
//
//  Created by zxh on 14-5-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHListSelectHandle.h"

@class SampleMenuVO;
@interface NoPrintMenuItem : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;

@property (nonatomic, strong) SampleMenuVO* item;
@property (nonatomic, strong) id<DHListSelectHandle> delegate;

-(void) loadItem:(SampleMenuVO*)data delegate:(id<DHListSelectHandle>)delegate;

-(IBAction)btnChange:(id)sender;

@end
