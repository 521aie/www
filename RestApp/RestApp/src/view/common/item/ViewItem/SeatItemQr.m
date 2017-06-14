//
//  EditItemQr.m
//  RestApp
//
//  Created by zxh on 14-10-11.
//  Copyright (c) 2014年 杭州迪火科技有限公司. All rights reserved.
//

#import "SeatItemQr.h"
#import "NSString+Estimate.h"
#import "ColorHelper.h"
#import "UIImageView+WebCache.h"
#import "UIView+Sizes.h"
#import "KeyUtils.h"
#import "RestConstants.h"
#import "Platform.h"
#import "UIImageView+WebCache.h"
#import "QRCodeGenerator.h"
#import "JsonHelper.h"
#import "ServiceFactory.h"
#import "TDFKabawService.h"

@implementation SeatItemQr

-(void) awakeFromNib
{
    [super awakeFromNib];
    service = [ServiceFactory Instance].kabawService;
    
    [[NSBundle mainBundle] loadNibNamed:@"SeatItemQr" owner:self options:nil];
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
    self.seat=seat;
    [[TDFKabawService new] loadSeatQRCodeWith:self.seat.code sucess:^(NSURLSessionDataTask * _Nonnull task, id _Nonnull data) {
        if ([ObjectUtil isNotEmpty:data]) {
            NSArray *list = [JsonHelper transList:[data objectForKey:@"data"]];
            NSString *shortUrl = nil;
            if (list.count > 0) {
                NSMutableDictionary *dic = list[0];
                shortUrl = [dic objectForKey:@"shortUrl"];
            }
            
            NSString* seatName=[NSString stringWithFormat:@"%@(%@)",self.seat.name,self.seat.code];
            self.img.image = [self createImg:shortUrl name:seatName];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [AlertBox show:error.localizedDescription];
    }];
}
- (void)loadSeatQRFinish:(RemoteResult *)result
{
    if (result.isRedo) {
        return;
    }
    if (!result.isSuccess) {
        [AlertBox show:result.errorStr];
        return;
    }

    NSDictionary *map = [JsonHelper transMap:result.content];
    if ([ObjectUtil isNotEmpty:map]) {
        NSArray *list = [JsonHelper transList:[map objectForKey:@"data"]];
        NSString *shortUrl = nil;
        if (list.count > 0) {
            NSMutableDictionary *dic = list[0];
            shortUrl = [dic objectForKey:@"shortUrl"];
        }
        
        NSString* seatName=[NSString stringWithFormat:@"%@(%@)",self.seat.name,self.seat.code];
        self.img.image = [self createImg:shortUrl name:seatName];
    }
}

- (UIImage*)createImg:(NSString*)content name:(NSString*)seatName
{
   UIImage* img = [QRCodeGenerator qrImageForString:content imageSize:self.img.bounds.size.width];
   CGSize finalSize=CGSizeMake(400, 400);
   UIGraphicsBeginImageContext(finalSize);
   [img drawInRect:CGRectMake(30,30,340,340)];
   
    
    NSString* headStr=[NSString stringWithFormat:NSLocalizedString(@"桌号:%@", nil),seatName];
    [headStr drawInRect:CGRectMake(0, 0, 400, 30) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    NSString* endStr=NSLocalizedString(@"点菜、加菜、结账、服务铃", nil);
    [endStr drawInRect:CGRectMake(0, 370, 400, 30) withFont:[UIFont systemFontOfSize:25] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return newImage;
}

- (IBAction)btnSaveClick:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"您确认要保存到本地相册吗？", nil) delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"确认", nil),NSLocalizedString(@"取消", nil), nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    ;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:NSLocalizedString(@"确认", nil)])
    {
        UIImageWriteToSavedPhotosAlbum([self.img image], nil, nil,nil);
    }
}

-(void) visibal:(BOOL)show
{
    [self setHeight:show?[self getHeight]:0];
    self.alpha=show?1:0;
}


@end
