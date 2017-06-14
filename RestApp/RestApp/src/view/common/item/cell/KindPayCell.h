//
//  KindPayCell.h
//  RestApp
//
//  Created by zxh on 14-7-7.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ISampleListEvent.h"
#import "KindPay.h"

@interface KindPayCell : UITableViewCell<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblKind;
@property (strong, nonatomic) IBOutlet UILabel *lblIsInclude;
@property (weak, nonatomic) IBOutlet UIImageView *nextImg;
@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) KindPay* obj;

-(void) initDelegate:(id<ISampleListEvent>)temp obj:(KindPay*)objTemp;
-(IBAction) btnDelClick:(id)sender;

@end
