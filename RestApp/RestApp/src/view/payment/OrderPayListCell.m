//
//  OrderPayListCell.m
//  RestApp
//
//  Created by 果汁 on 15/9/18.
//  Copyright (c) 2015年 杭州迪火科技有限公司. All rights reserved.
//
#import "AlertImageView.h"
#import "OrderPayListCell.h"
#import "UIView+Sizes.h"
#import "NSString+Estimate.h"
#import "CustomAlertView.h"
#import "TDFPaymentTypeVo.h"
@interface OrderPayListCell ()

@end

@implementation OrderPayListCell
-(UILabel *)payName
{
    if(!_payName) {
        _payName = [[UILabel alloc] init];
        _payName.textColor = [UIColor whiteColor];
        _payName.font = [UIFont systemFontOfSize:18];
        _payName.frame = CGRectMake(8, 8, 180, 23);
    }
    return _payName;
}
-(UILabel *)intoCountMoney
{
    if(!_intoCountMoney) {
        _intoCountMoney = [[UILabel alloc] init];
        _intoCountMoney.textColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:1];
        _intoCountMoney.font = [UIFont systemFontOfSize:14];
        _intoCountMoney.frame = CGRectMake(SCREEN_WIDTH-90, 8, 65, 23);
        _intoCountMoney.textAlignment = NSTextAlignmentCenter;
    }
    return _intoCountMoney;
}
-(UILabel *)payType
{
    if(!_payType) {
        _payType = [[UILabel alloc] init];
        _payType.textColor = [UIColor whiteColor];
        _payType.font = [UIFont systemFontOfSize:12];
        _payType.frame = CGRectMake(SCREEN_WIDTH-120, 32, 102, 15);
        _payType.textAlignment = NSTextAlignmentCenter;
    }
    return _payType;
}
-(UILabel *)orIntoMyCount
{
    if(!_orIntoMyCount) {
        _orIntoMyCount = [[UILabel alloc] init];
        _orIntoMyCount.font = [UIFont systemFontOfSize:12];
        _orIntoMyCount.frame = CGRectMake(SCREEN_WIDTH-98, 50, 50, 15);
        _orIntoMyCount.textAlignment = NSTextAlignmentCenter;
    }
    return _orIntoMyCount;
}
-(UILabel *)way
{
    if(!_way) {
        _way = [[UILabel alloc] init];
        _way.textColor = [UIColor whiteColor];
        _way.font = [UIFont systemFontOfSize:12];
        _way.frame = CGRectMake(SCREEN_WIDTH-130, 8, 70, 21);
    }
    return _way;
}
 -(UIImageView *)iconext
{
    if (!_iconext) {
        _iconext = [[UIImageView alloc]init];
        _iconext.frame = CGRectMake(SCREEN_WIDTH-40, 30, 20, 27);
        _iconext.image = [UIImage imageNamed:@"ico_next_w.png"];
    }
    return _iconext;
}
-(void)initWithData:(OrderPayListData *)orderPayListData{
    [self.backView addSubview:self.payName];
    [self.backView addSubview:self.intoCountMoney];
    [self.backView addSubview:self.payType];
     [self.backView addSubview:self.orIntoMyCount];
    [self.backView addSubview:self.way];
     [self.backView addSubview:self.iconext];
    self.orderId.delegate =  self;
   self.backView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    self.payName.text = orderPayListData.wechatNickName;
    self.payType.text = [NSString stringWithFormat:NSLocalizedString(@"%@支付", nil),[self getOrderName:orderPayListData.payType]];
    self.orderName.text = [NSString stringWithFormat:NSLocalizedString(@"%@账单号:", nil),[self getOrderName:orderPayListData.payType]];

    if (orderPayListData.type ==1) {
        self.way.text = NSLocalizedString(@"消费收入", nil);
        self.iconext.hidden = NO;
        self.seatName.text = [NSString stringWithFormat:NSLocalizedString(@"桌号： %@", nil),orderPayListData.seatName];
                if ([NSString isBlank:orderPayListData.seatName]){
                        self.seatName.text = NSLocalizedString(@"桌号：", nil);
                }
        self.innerCode.text =  [NSString stringWithFormat:NSLocalizedString(@"流水号：%@", nil),orderPayListData.innerCode];
                if ([NSString isBlank: orderPayListData.innerCode ]) {
                        self.innerCode.text = NSLocalizedString(@"流水号：", nil);
                }
    }else{
        self.way.text = NSLocalizedString(@"充值收入", nil);
        self.iconext.hidden = YES;
        
        if ([NSString isBlank:orderPayListData.seatName]){
            self.seatName.text = [NSString stringWithFormat:NSLocalizedString(@"会员卡号： %@", nil),orderPayListData.cardNo];
            
        }
        
        if ([NSString isBlank: orderPayListData.innerCode ]) {
            if (orderPayListData.kindCardName ==NULL) {
                self.innerCode.text =  [NSString stringWithFormat:NSLocalizedString(@"会员卡类型：无", nil)];
            }else{
            self.innerCode.text =  [NSString stringWithFormat:NSLocalizedString(@"会员卡类型：%@", nil),orderPayListData.kindCardName];
            }
        }
    }
    NSTimeInterval time= orderPayListData.payTime/1000.0;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    self.payTime.text =currentDateStr;
    self.intoCountMoney.text= [NSString stringWithFormat:@"+%.2f",orderPayListData.wxPay];
    self.intoCountMoney.textColor = [UIColor greenColor];

    self.mobile.text = [NSString stringWithFormat:NSLocalizedString(@"手机号：%@", nil),orderPayListData.mobile];
    if ([NSString isBlank:orderPayListData.mobile]) {
        self.mobile.text = NSLocalizedString(@"手机号：无", nil);
    }
    
    self.orderId.text =orderPayListData.transcationId;
    self.orIntoMyCount.text= orderPayListData.shareBillStatusMsg;
    if([self.orIntoMyCount.text isEqualToString:NSLocalizedString(@"未到账", nil)]){
        self.orIntoMyCount.textColor=[UIColor redColor];
    }else{
        self.orIntoMyCount.textColor=[UIColor greenColor];
    }

    if([NSString isNotBlank:orderPayListData.refundTransactionId]){
      self.way.text = NSLocalizedString(@"已退款", nil);
      self.intoCountMoney.text= [NSString stringWithFormat:@"-%.2f",orderPayListData.wxPay];
      self.orderName.text = NSLocalizedString(@"退款流水号:", nil);
      self.orderId.text = orderPayListData.refundTransactionId;
      self.intoCountMoney.textColor = [UIColor redColor];
    }
    
    [self.orderName sizeToFit];
    [self.orderId setLeft:CGRectGetMaxX(self.orderName.frame)];
    [self.orderId setWidth:SCREEN_WIDTH-20-CGRectGetMaxX(self.orderName.frame)];

    //更新UI
    BOOL isCodePay = [orderPayListData.wechatNickName isEqualToString:NSLocalizedString(@"支付宝付款码支付", nil)] && orderPayListData.payType == 2;
    self.mobile.hidden = isCodePay;
    self.payName.attributedText = [self attributeString:orderPayListData.wechatNickName isCodePay:isCodePay];
    [self.orderName setTop:isCodePay?83:100];
    [self.orderId setTop:isCodePay?83:100];
    [self.line setTop:isCodePay?104:119];
    [self.backView setHeight:isCodePay?105:120];
    
 }

-(NSString *)getOrderName:(NSInteger)payType{
    
    NSString *string;
    switch (payType) {
        case Weixin:
            string= NSLocalizedString(@"微信", nil);
            break;
        case Alipay:
            string = NSLocalizedString(@"支付宝", nil);
            break;
        case Packet:
            string = NSLocalizedString(@"二维火", nil);
            break;
        case QQ:
            string = NSLocalizedString(@"QQ钱包", nil);
            break;
            
    }
    return string;
}


-(NSAttributedString *)attributeString:(NSString *)payName isCodePay:(BOOL)isCodePay{
    
    NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                                 NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                 NSForegroundColorAttributeName: [UIColor whiteColor] };
    if (isCodePay) {
        return  [[NSAttributedString alloc] initWithString: payName attributes: attrDict2];
    } else{
        
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"付款人：", nil) attributes: attrDict1];
        if ([NSString isBlank:payName]) {
            return attrStr;
        }else{
        
            [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:payName attributes: attrDict2]];
            return  attrStr;
        }
       
    }
}


-(void)copyEventFininshed{
 
    AlertTextView * alertView = [[AlertTextView alloc]initWithContent:[NSString stringWithFormat: NSLocalizedString(@"%@已经复制，可以粘贴使用", nil), [self.orderName.text substringToIndex:self.orderName.text.length-1]] location:[UIApplication sharedApplication].keyWindow.center];
    [alertView setBackColor:[UIColor blackColor] alpha:0.7  textColor:[UIColor whiteColor]];
    [alertView setViewSizeFont:nil label:220];
    [alertView showAlertView];
    [alertView dismissAfterTimeInterval:4.0f alertFinish:nil];

 }
@end
