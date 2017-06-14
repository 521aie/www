//
//  SmallImageItem.h
//  RestApp
//
//  Created by Shaojianqing on 15/6/30.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignBillNoPayVO.h"
#import "SignBillPayDetailVO.h"

@interface SignBillPayTotalItem : UIView

@property (nonatomic, strong) IBOutlet UILabel *lblFee;
@property (nonatomic, strong) IBOutlet UILabel *lblTime;
@property (nonatomic, strong) IBOutlet UILabel *lblTradeNo;
@property (nonatomic, strong) IBOutlet UILabel *lblSigner;

+ (SignBillPayTotalItem *)getInstance;

- (void)initWithSignBillNoPayVO:(SignBillNoPayVO *)data;

- (void)initWithSignBillPayDetailVO:(SignBillPayDetailVO *)data;

@end
