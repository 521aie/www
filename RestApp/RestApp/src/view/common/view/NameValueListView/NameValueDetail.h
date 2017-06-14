//
//  NameValueDetail.h
//  RestApp
//
//  Created by 刘红琳 on 16/1/21.
//  Copyright © 2016年 杭州迪火科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameValueDetail : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UILabel *lblVal;
@property (weak, nonatomic) IBOutlet UILabel *lblCodeText;

@end
