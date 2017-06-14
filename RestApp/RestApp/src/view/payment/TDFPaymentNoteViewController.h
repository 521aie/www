//
//  TDFPaymentNoteViewController.h
//  RestApp
//
//  Created by Xihe on 17/3/30.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import "TDFRootViewController.h"
#import "TDFDataCenter.h"

@interface TDFPaymentNoteViewController : TDFRootViewController
@property (nonatomic,strong) NSString *bankAccountLst;//账号
@property (nonatomic,strong) NSString *accountBankLst;//开户行
@property (nonatomic,strong) NSString *accountNameTxt;//开户人
@property (nonatomic,strong) NSString *personName;//负责人姓名
@property (nonatomic,strong) NSString *personMobile;//负责人手机
@property (nonatomic,strong) NSString *address;//详细地址
@property (nonatomic,strong) NSString *shopName;//店铺名

@end
