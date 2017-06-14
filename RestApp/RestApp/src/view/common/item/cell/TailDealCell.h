//
//  TailDealCell.h
//  RestApp
//
//  Created by zxh on 14-7-8.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ISampleListEvent.h"
#import "TailDeal.h"

@interface TailDealCell : UITableViewCell<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblVal;

@property (nonatomic,strong) id<ISampleListEvent> delegate;
@property (strong, nonatomic) TailDeal* obj;
@property (weak, nonatomic) IBOutlet UIImageView *deleteIcon;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


-(void) initDelegate:(id<ISampleListEvent>)temp obj:(TailDeal*)objTemp;
-(IBAction) btnDelClick:(id)sender;


@end
