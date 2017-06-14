//
//  EditItemQr.m
//  RestApp
//
//  Created by zxh on 14-10-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "EditItemQr.h"

#import "EditItemImage.h"
#import "NSString+Estimate.h"
#import "ColorHelper.h"
#import "UIImageView+WebCache.h"
#import "UIView+Sizes.h"
#import "UIImageView+WebCache.h"

@implementation EditItemQr

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"EditItemQr" owner:self options:nil];
    [self addSubview:self.view];
}

#pragma  initHit.
- (void)initHit:(NSString *)_hit
{
    self.lblDetail.text=nil;
    [self.lblDetail setWidth:300];
    self.lblDetail.text=_hit;
    [self.lblDetail setTextColor:[ColorHelper getTipColor6]];
    if([NSString isBlank:_hit]){
        [self.lblDetail setHeight:0];
        [self.line setTop:250];
    }else{
        [self.lblDetail sizeToFit];
        [self.line setTop:(self.lblDetail.top+self.lblDetail.height+2)];
    }
    [self.view setHeight:[self getHeight]];
    [self setHeight:[self getHeight]];
}

- (float) getHeight{
    return self.line.top+self.line.height+1;
}

- (void)initLabel:(NSString*)label withHit:(NSString *)_hit
{
    self.lblName.text=label;
    [self initHit:_hit];
}

- (void)loadSeat:(Seat*)seat
{
    
}

@end
