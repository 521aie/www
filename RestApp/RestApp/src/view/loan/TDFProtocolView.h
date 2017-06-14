//
//  TDFProtocolView.h
//  RestApp
//
//  Created by suckerl on 2017/6/1.
//  Copyright © 2017年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProtocolDelegate <NSObject>
- (void)protocolViewSelBtnClick:(UIButton*)btn;
//服务协议点击
- (void)protocolViewAgreementClick;
@end

@interface TDFProtocolView : UIView
@property (weak, nonatomic) id<ProtocolDelegate> delegate;
@end
