//
//  CusButton.m
//  RestApp
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import "CusButton.h"
#import "ImageUtils.h"
#import "NSString+Estimate.h"
#import "UIImageView+WebCache.h"


@implementation CusButton


-(id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        [super awakeFromNib];
        [[NSBundle mainBundle] loadNibNamed:@"CusButton" owner:self options:nil];
        [self addSubview:self.view];
       
 
    }return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"CusButton" owner:self options:nil];
    [self addSubview:self.view];
    
}

- (IBAction)btnClick:(UIButton *)sender {
    
    [self.delegate MuluteDelegateTag:self];
}

-(void)initDelegate:(id<OrderMuluteDelegate>)delegate
{
    self.delegate =delegate;
}

- (void)changeImg:(NSString  *)imgPath name:(NSString *)name imgcolor:(UIColor *)color Bgcolor:(UIColor *)Bgcolor select:(BOOL)select  hidecolor:(UIColor *)hidecolor 

{
    self.DetailLbl.text =[NSString stringWithFormat:@"%@",name];
    [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString urlFilterRan:imgPath]]placeholderImage:[UIImage imageNamed:@"Ico_Cold_Disc"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *changeImg = [self imageWithColor:color imag:image];
        self.img.image =changeImg;
        [self loadRadiusWithcolor:color isselect:select bgcolor:Bgcolor  origincolor:color];
    }];
   
}

- (void)loadRadiusWithcolor:(UIColor *)color isselect:(BOOL)select  bgcolor:(UIColor*)bgcolor
{
    self.imgBg.hidden=NO;
    self.imgBg.layer.masksToBounds=YES;
    self.imgBg.layer.cornerRadius=self.imgBg.frame.size.width*0.5;
    if (!select ) {
      self.imgBg.layer.backgroundColor=color.CGColor;
      self.DetailLbl.textColor =[UIColor blackColor];
    }
    else
    {
       self.imgBg.layer.backgroundColor=bgcolor.CGColor;
         self.DetailLbl.textColor =[UIColor whiteColor];
    }
   
}
- (void)loadRadiusWithcolor:(UIColor *)color isselect:(BOOL)select  bgcolor:(UIColor*)bgcolor origincolor:(UIColor*)origincolor
{
    
    self.imgBg.hidden=NO;
    self.imgBg.layer.masksToBounds=YES;
    self.imgBg.layer.cornerRadius=self.imgBg.frame.size.width*0.5;
    if (!select ) {
        self.imgBg.layer.backgroundColor=[UIColor whiteColor].CGColor;
        self.DetailLbl.textColor =[UIColor blackColor];
        UIImage *changeImg = [self imageWithColor:origincolor imag:self.img.image];
        self.img.image =changeImg;
    }
    else
    {
        self.imgBg.layer.backgroundColor=bgcolor.CGColor;
        self.DetailLbl.textColor =[UIColor whiteColor];
        UIImage *changeImg = [self imageWithColor:[UIColor whiteColor] imag:self.img.image];
        self.img.image =changeImg;
    }
}


- (UIImage *)imageWithColor:(UIColor *)color imag:(UIImage *)img
{
    UIGraphicsBeginImageContextWithOptions(img.size, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextClipToMask(context, rect, img.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsPopContext();
    return newImage;
}

@end
