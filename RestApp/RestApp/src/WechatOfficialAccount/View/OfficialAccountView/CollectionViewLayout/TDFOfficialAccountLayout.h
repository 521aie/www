//
//  TDFOfficialAccountLayout.h
//  TDFFakeOfficialAccount
//
//  Created by Octree on 5/2/17.
//  Copyright © 2017年 Octree. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDFOfficialAccountLayoutDelegate  <UICollectionViewDelegate>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TDFOfficialAccountLayout : UICollectionViewFlowLayout

@property (nonatomic, readonly) CGFloat itemWidth;
/**
 *  Default : 5
 */
@property (nonatomic) CGFloat sectionPadding;

@end
