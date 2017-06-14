//
//  MultiNameValueCell.h
//  RestApp
//
//  Created by zxh on 14-5-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMultiNameValueItem.h"
#import "ISampleListEvent.h"
@interface MultiNameValueCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgCheck;
@property (nonatomic, strong) IBOutlet UIImageView *imgUnCheck;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblVal;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;
@property (nonatomic, strong) id<IMultiNameValueItem> item;
@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) NSTimer* timer;

- (void) fillObj:(id<IMultiNameValueItem>)tempObj delegate:(id<ISampleListEvent>) delegate;

- (void) showBtnEdit;

- (IBAction)btnMultiClick:(id)sender;

- (IBAction)btnEditClick:(id)sender;

@end