//
//  TDFLoanWebViewController.h
//  RestApp
//
//  Created by zishu on 16/8/16.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "ShopDetail.h"
#import "TDFReportWebViewController.h"

@interface TDFLoanWebViewController : TDFReportWebViewController
@property (nonatomic ,strong) ShopDetail* shopDetail;
@property (nonatomic ,strong) NSString *h5Url;;
@end
