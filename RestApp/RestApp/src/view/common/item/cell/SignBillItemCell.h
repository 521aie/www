//
//  MenuTimePriceCell.h
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "SignBillPayNoPayOptionTotalVO.h"

@interface SignBillItemCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblCount;
@property (nonatomic, strong) IBOutlet UILabel *lblAmount;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;

@property (nonatomic, strong) SignBillPayNoPayOptionTotalVO *data;

- (void)initWithData:(SignBillPayNoPayOptionTotalVO *)data;

@end
