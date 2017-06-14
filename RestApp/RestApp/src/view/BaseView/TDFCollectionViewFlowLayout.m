//
//  TDFCollectionViewFlowLayout.m
//  RestApp
//
//  Created by 黄河 on 2016/10/28.
//  Copyright © 2016年 Êù≠Â∑ûËø™ÁÅ´ÁßëÊäÄÊúâÈôêÂÖ¨Âè∏. All rights reserved.
//

#import "TDFCollectionViewFlowLayout.h"
#import "TDFSectionDecorationReusableView.h"
@implementation TDFCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemAttributes = [NSMutableArray array];
    NSInteger numberSection = self.collectionView.numberOfSections;
    for (int i = 0; i < numberSection; i ++) {
        NSInteger lastIndex = [self.collectionView numberOfItemsInSection:i]-1;
        if (lastIndex < 0) {
            continue;
        }
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:lastIndex inSection:i]];
        UIEdgeInsets sectionInset = self.sectionInset;
        CGRect frame = CGRectUnion(firstItem.frame, lastItem.frame);
        frame.origin.x = frame.origin.x - sectionInset.left/2.0;
        frame.origin.y = frame.origin.y - sectionInset.top - self.sectionHeight;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            frame.size.width += sectionInset.left/2.0 + sectionInset.right/2.0;
            frame.size.height = self.collectionView.frame.size.height;
        }else
        {
            frame.size.width = self.collectionView.frame.size.width - sectionInset.left;
            frame.size.height += sectionInset.top + sectionInset.bottom + self.sectionHeight;
        }
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"DecorationViewOfKindString" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        attributes.frame = frame;
        attributes.zIndex = -1;
        [self.itemAttributes addObject:attributes];
        [self registerClass:[TDFSectionDecorationReusableView class] forDecorationViewOfKind:@"DecorationViewOfKindString"];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    for (UICollectionViewLayoutAttributes *attribute in self.itemAttributes) {
        if (!CGRectIntersectsRect(attribute.frame, rect)) {
            continue;
        }
        [attributes addObject:attribute];
    }
    return attributes;
}

@end
