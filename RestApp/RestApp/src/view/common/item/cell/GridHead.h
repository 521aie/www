//
//  GridHead.h
//  RestApp
//
//  Created by zxh on 14-7-14.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"

@class INameValueItem;
@interface GridHead : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *imgAdd;
@property (nonatomic, strong) IBOutlet UIImageView *imgEdit;
@property (nonatomic, strong) IBOutlet UIButton *btnAdd;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;
@property (nonatomic, strong) IBOutlet UIView *panel;

@property (nonatomic, strong) id<ISampleListEvent> delegate;
@property (nonatomic, strong) id<INameValueItem> obj;
@property (nonatomic, strong) NSString* event;

+(id)getInstance:(UITableView *)tableView;

- (void)initTitle:(NSString *)objTemp;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(id<INameValueItem>)objTemp event:(NSString*)event;

-(void) initOperateWithAdd:(BOOL)addEnable edit:(BOOL)editEnable;

-(IBAction) btnEditClick:(id)sender;

-(IBAction) btnAddClick:(id)sender;

@end
