//
//  MenuTimePriceCell.h
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "SignBillNoPayVO.h"

@class SignBillDetailView;
@interface SignBillNoPayItemCell : UITableViewCell
{
    SignBillDetailView *signBillDetailView;
}
@property (nonatomic, strong) IBOutlet UILabel *lblFee;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UILabel *lblTradeNo;
@property (nonatomic, strong) IBOutlet UILabel *lblSigner;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) IBOutlet UIImageView *imgSelect;

@property (nonatomic, strong) SignBillNoPayVO *data;

- (IBAction)selectBtnClick:(id)sender;

- (IBAction)itemBtnClick:(id)sender;

- (void)initWithData:(SignBillNoPayVO *)data payIdSet:(NSArray *)payIdSet target:(SignBillDetailView *)target;

@end
