//
//  MenuTimePriceCell.h
//  RestApp
//
//  Created by zxh on 14-6-28.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SignBill.h"
#import <UIKit/UIKit.h>
#import "ISampleListEvent.h"
#import "SignBillNoPayVO.h"

@class SignBillRecordView;
@interface SignBillRecordItemCell : UITableViewCell
{
    SignBillRecordView *signBillRecordView;
}
@property (nonatomic, strong) IBOutlet UILabel *lblFee;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UILabel *lblStatus;
@property (nonatomic, strong) IBOutlet UILabel *lblSigner;

- (void)initWithData:(SignBill *)data target:(SignBillRecordView *)target;

@end
