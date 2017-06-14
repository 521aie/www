//
//  FuctionPopView.m
//  RestApp
//
//  Created by iOS香肠 on 15/12/18.
//  Copyright © 2015年 杭州迪火科技有限公司. All rights reserved.
//

#import "FuctionPopView.h"
#import "NSString+Estimate.h"
#import "UIView+Sizes.h"




@implementation FuctionPopView

-(id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}
-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"FuctionPopView" owner:self options:nil];
    self.popview.layer.cornerRadius =4;
    self.blankview.layer.cornerRadius =4;
    self.popview.layer.masksToBounds =YES;
    [self addSubview:self.containView];
}

- (IBAction)selectDelete:(id)sender {
    
    [self.superview setHidden:YES];
    
}
- (CGFloat)textHeight:(NSString *)string
{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(265, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.height;
}

- (void)loadDatawithMenuAction:(UIMenuDetaiAction *)menuaction section:(NSInteger)section
{
    if ([NSString isNotBlank:menuaction.img]) {
        self.imgTitlePic .image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",menuaction.img]];
    }
    else
    {
        self.imgTitlePic.image =nil;
    }
    if ([NSString isNotBlank:menuaction.name]) {
        
        if ([menuaction.name isEqualToString:NSLocalizedString(@"“火小二”生活圈", nil)])
        {
            self.lblTitle.text =[NSString stringWithFormat:NSLocalizedString(@"生活圈", nil)];
        }
        else if ([menuaction.name isEqualToString:NSLocalizedString(@"火小二", nil)])
        {
           self.lblTitle.text =[NSString stringWithFormat:NSLocalizedString(@"顾客端设置", nil)];
        }
        else
        {
        self.lblTitle.text =[NSString stringWithFormat:@"%@",menuaction.name];
        }
    }
    else
    {
        self.lblTitle.text =@"";
    }
    if ([NSString isNotBlank:menuaction.content]) {
        self.contentlbl.text =[NSString stringWithFormat:@"%@",menuaction.content];
       
    }
    else
    {
        self.contentlbl.text =@"";
    }
    if (menuaction.selectstatus) {
       
        self.imgPic.image =[UIImage imageNamed:@"ico_check.png"];
        if (section==0) {
            self.showlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"此功能在首页显示", nil)];

        }
        else
        {
        self.showlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"此功能在左侧栏显示", nil)];
        }
    }
    else
    {
        self.imgPic.image =[UIImage imageNamed:@"ico_uncheck.png"];
        if (section==0) {
            self.showlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"此功能在首页隐藏", nil)];
            
        }
        else
        {
            self.showlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"此功能在左侧栏隐藏", nil)];
        }

        
    }
    
    if (menuaction.isAdviceShow) {
        
        self.subjectlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"(建议设置为显示)", nil)];
    }
    else
    {
        self.subjectlbl.text =[NSString stringWithFormat:@"%@",NSLocalizedString(@"(建议设置完成后隐藏)", nil)];

    }
    if ([menuaction.name isEqualToString:NSLocalizedString(@"微信支付", nil)]) {
    if ( [[Platform Instance]lockAct:PAD_WEIXIN_DETAL]&&[[Platform Instance]lockAct:PAD_WEIXIN_SUM]&& [[[Platform Instance]getkey:USER_IS_SUPER]isEqualToString:@"0"]) {
        [self.lock setHidden:NO];
        [self loadRadius];

        }
        else
        {
            [self.lock setHidden:YES];
        }
    }
    else if ([menuaction.name isEqual:NSLocalizedString(@"报表", nil)])
    {
        if ([[Platform Instance]lockAct:MEMBER_REPORT]&&[[Platform Instance]lockAct:CARD_CONSUME_DETAIL_REPORT]&&[[Platform Instance]lockAct:PAD_CARD_ACTIVATE_REPORT]&&[[Platform Instance]lockAct:   PAD_DETAIL_CARD_REPORT]&&[[Platform Instance]lockAct: CARD_DISCOUNT_DETAIL_REPORT]&&[[Platform Instance]lockAct:CARD_CHARGE_DETAIL_REPORT]&&[[Platform Instance]lockAct:CARD_DEGREE_DETAIL_REPORT]&&[[Platform Instance]lockAct: CARD_CHANGE_DETAIL_REPORT]&&[[Platform Instance]lockAct: CARD_CHANGE_COUNT_REPORT]) {
            if ([[Platform Instance] lockAct:SURFACE_REPORT]) {
                [self.lock setHidden:NO];
                [self loadRadius];
            }else{
                [self.lock setHidden:YES];
            }
        }
        else
        {
            [self.lock setHidden:YES];
        }
        
    }
    else if ([menuaction.name isEqualToString:NSLocalizedString(@"会员", nil)])
    {
        if ([[Platform Instance] lockAct:PAD_DEGREE_EXCHANGE]&&[[Platform Instance] lockAct:PAD_CHARGE_DISCOUNT]&&[[Platform Instance] lockAct:PAD_KIND_CARD]&&[[Platform Instance] lockAct:PAD_MAKE_CARD]&&[[Platform Instance] lockAct:PAD_CONSUME_DETAIL]) {
            [self.lock setHidden:NO];
            [self loadRadius];
            
        }
        else
        {
            [self.lock setHidden:YES];
        }
        
    }
    else
    {
    BOOL isShow =[[Platform Instance] isNetworkOk] && [[Platform Instance] lockAct:menuaction.code];
    [self.lock setHidden:!isShow];
    if (isShow) {
        [self loadRadius];
    }
    else
    {
        self.imgArr.hidden=YES;
    }
    }
    [self upsizeheightwithData:menuaction];
}
- (void)upsizeheightwithData:(UIMenuDetaiAction *)menuaction
{
    CGRect contenlblframe =self.contentlbl.frame;
    contenlblframe.size.height =[self textHeight:menuaction.content];
    self.contentlbl.frame =contenlblframe;
    
    
    CGRect Contentframe = self.contentView.frame;
    Contentframe.size.height =self.contentlbl.frame.size.height +self.contentlbl.frame.origin.y;
    self.contentView.frame =Contentframe;
    
    CGRect blankviewframe = self.blankview.frame;
    blankviewframe.origin.y =self.contentView.origin.y+self.contentView.size.height;
    blankviewframe.size.height= 10;
    self.blankview.frame =blankviewframe;
    
    CGRect Popviewframe = self.popview.frame;
    Popviewframe.size.height = self.blankview.frame.size.height+self.blankview.frame.origin.y +85;
    self.popview.frame =Popviewframe;
    
    CGRect containerframe =self.containView.frame;
    containerframe.size.height =self.popview.frame.origin.y+self.popview.frame.size.height;
    self.containView.frame =containerframe;
  
    
}
- (CGFloat)totalheightwithdata:(UIMenuDetaiAction *)menuaction
{
    CGRect contenlblframe =self.contentlbl.frame;
    contenlblframe.size.height =[self textHeight:menuaction.content];
    self.contentlbl.frame =contenlblframe;
    
    
    CGRect Contentframe = self.contentView.frame;
    Contentframe.size.height =self.contentlbl.frame.size.height +self.contentlbl.frame.origin.y;
    self.contentView.frame =Contentframe;
    
    CGRect blankviewframe = self.blankview.frame;
    blankviewframe.origin.y =self.contentView.origin.y+self.contentView.size.height;
     blankviewframe.size.height= 10;
    self.blankview.frame =blankviewframe;
    
    CGRect Popviewframe = self.popview.frame;
    Popviewframe.size.height = self.blankview.frame.size.height+self.blankview.frame.origin.y +85;
    self.popview.frame =Popviewframe;
    
    CGRect containerframe =self.containView.frame;
    containerframe.size.height =self.popview.frame.origin.y+self.popview.frame.size.height;
    self.containView.frame =containerframe;
    
    return self.containView.frame.size.height;
}
- (void)loadRadius
{
    self.imgArr.hidden=NO;
    self.imgArr.layer.masksToBounds=YES;
    self.imgArr.layer.cornerRadius=self.imgArr.frame.size.width*0.5;
    self.imgArr.layer.backgroundColor=[UIColor grayColor].CGColor;
}


@end
